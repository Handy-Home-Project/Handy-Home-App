using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class FurnitureMessageData
{
    public string filename;
    //public Vector3Serializable position; // 위치 정보
}

public class FurnitureLoader : MonoBehaviour
{
    public string[] fbxFileNames = { "" };
    public int currentObjectIndex = 0;

    private List<GameObject> spawnedObjects = new List<GameObject>();
    private GameObject selectedObject;
    private Camera mainCamera;
    private bool isDragging = false;
    private Vector3 dragOffset;
    private float rotationSpeed = 90f;
    // 카메라 회전 관련
    private float mouseX = 0f;
    private float mouseY = 0f;
    private bool isCameraRotating = false;
    private Vector3 dragOrigin;

    // 컨트롤 모드
    public enum ControlMode
    {
        Move,
        Rotate,
        Size,
        Camera  // 카메라 모드 추가
    }

    private ControlMode currentMode = ControlMode.Move;

    private void Start()
    {
        mainCamera = Camera.main;
        if (mainCamera == null)
            mainCamera = FindObjectOfType<Camera>();

        // 첫 번째 객체 로드
        for (int i = 0; i < fbxFileNames.Length; i++)
        {
            LoadObject(i);
        }
    }

    private void Update()
    {
        HandleInput();
    }

    // 모든 입력 처리
    void HandleInput()
    {
        // 모드별 입력 처리
        if (currentMode == ControlMode.Camera)
        {
            HandleCameraInput();
        }
        else if (currentMode == ControlMode.Rotate)
        {
            HandleMouseRotateInput();
        }
        else if (selectedObject != null && currentMode == ControlMode.Size)
        {
            float scroll = Input.GetAxis("Mouse ScrollWheel"); // 스크롤 입력값 (-1~+1)
            if (Mathf.Abs(scroll) > 0.01f)
            {
                // 현재 크기에 따라 상대적으로 비율 조정 (최소/최대값 제한 가능)
                Vector3 currScale = selectedObject.transform.localScale;
                float scaleFactor = 1f + scroll * 3f;
                Vector3 newScale = currScale * scaleFactor;

                // 최소/최대 크기 제한 (예: 0.1~10배)
                newScale = Vector3.Max(newScale, Vector3.one * 0.1f);
                newScale = Vector3.Min(newScale, Vector3.one * 10f);

                selectedObject.transform.localScale = newScale;
            }
        }
        else
        {
            // 마우스 입력
            HandleMouseInput();
        }
    }

    // 카메라 입력 처리
    void HandleCameraInput()
    {
        float cameraMoveSpeed = 5f;
        if (Input.GetMouseButtonDown(0))
        {
            dragOrigin = Input.mousePosition;
            return;
        }

        if (Input.GetMouseButton(0))
        {
            Vector3 difference = Input.mousePosition - dragOrigin;

            // 화면 기준으로 카메라 이동 (카메라의 축 기준이 아님)
            Vector3 move = (-mainCamera.transform.right * difference.x + -mainCamera.transform.up * difference.y)
                           * cameraMoveSpeed * Time.deltaTime;

            mainCamera.transform.position += move;

            dragOrigin = Input.mousePosition;
        }


        // 마우스 우클릭으로 카메라 회전
        if (Input.GetMouseButtonDown(1))
        {
            isCameraRotating = true;
            Cursor.lockState = CursorLockMode.Locked;
        }

        if (Input.GetMouseButtonUp(1))
        {
            isCameraRotating = false;
            Cursor.lockState = CursorLockMode.None;
        }

        // 카메라 회전
        if (isCameraRotating)
        {
            float mousesensitivity = 5f;
            mouseX += Input.GetAxis("Mouse X") * mousesensitivity;
            mouseY -= Input.GetAxis("Mouse Y") * mousesensitivity;

            // 상하 회전 제한
            mouseY = Mathf.Clamp(mouseY, -90f, 90f);

            mainCamera.transform.rotation = Quaternion.Euler(mouseY, mouseX, 0);
        }

        // 마우스 스크롤로 줌
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0)
        {
            Vector3 forward = mainCamera.transform.forward;
            mainCamera.transform.position += forward * scroll * cameraMoveSpeed * Time.deltaTime * 10f;

            Debug.Log($"카메라 줌: {mainCamera.transform.position}");
        }
    }

    void HandleMouseRotateInput()
    {
        // 마우스 좌클릭 시작 시 위치 저장
        if (Input.GetMouseButtonDown(0))
        {
            SelectObjectUnderMouse();

            if (selectedObject != null && currentMode == ControlMode.Rotate)
            {
                StartDrag();
            }
        }

        // 드래그 진행
        if (Input.GetMouseButton(0) && isDragging && selectedObject != null)
        {
            float mouseDeltaX = Input.GetAxis("Mouse X");
            float rotationSpeed = 10f;
            selectedObject.transform.Rotate(0f, -mouseDeltaX * rotationSpeed, 0f, Space.World);
        }

        // 드래그 종료
        if (Input.GetMouseButtonUp(0) && isDragging)
        {
            EndDrag();
        }
    }

    // 마우스 입력 처리
    void HandleMouseInput()
    {
        // 마우스 클릭으로 객체 선택 및 드래그 시작
        if (Input.GetMouseButtonDown(0))
        {
            SelectObjectUnderMouse();

            // 선택된 객체가 있고 이동 모드일 때 드래그 시작
            if (selectedObject != null && currentMode == ControlMode.Move)
            {
                StartDrag();
            }
        }

        // 드래그 진행
        if (Input.GetMouseButton(0) && isDragging && selectedObject != null)
        {
            DragSelectedObject();
        }

        // 드래그 종료
        if (Input.GetMouseButtonUp(0) && isDragging)
        {
            EndDrag();
        }
    }

    // FBX 객체 로드
    void LoadObject(int index)
    {
        if (index < 0 || index >= fbxFileNames.Length) return;

        GameObject prefab = Resources.Load<GameObject>(fbxFileNames[index]);
        if (prefab != null)
        {
            GameObject newObj = Instantiate(prefab);
            newObj.transform.position = Vector3.zero;

            // 자동 콜라이더 생성 및 설정
            if (newObj.GetComponent<Collider>() == null)
            {
                // 자식 포함 모든 렌더러의 월드 범위 계산
                Renderer[] renderers = newObj.GetComponentsInChildren<Renderer>();
                if (renderers.Length > 0)
                {
                    Bounds combinedBounds = renderers[0].bounds;
                    foreach (var rend in renderers)
                    {
                        combinedBounds.Encapsulate(rend.bounds);
                    }

                    // BoxCollider 추가 및 설정
                    BoxCollider collider = newObj.AddComponent<BoxCollider>();
                    // 월드 좌표 중심값을 로컬 좌표로 변환
                    Vector3 localCenter = newObj.transform.InverseTransformPoint(combinedBounds.center);
                    collider.center = localCenter;
                    collider.size = combinedBounds.size;

                    Debug.Log($"콜라이더 설정 - center: {collider.center}, size: {collider.size}");
                }
                else
                {
                    // 렌더러 없으면 기본 크기 콜라이더 적용
                    BoxCollider collider = newObj.AddComponent<BoxCollider>();
                    collider.size = Vector3.one;
                    Debug.Log("Renderer가 없어 기본 콜라이더 크기 설정");
                }
            }

            // 필요시 레이어 지정 (예: 기본 레이어)
            if (newObj.layer == 0)
            {
                newObj.layer = 0; // Default 레이어 설정
            }

            spawnedObjects.Add(newObj);
            selectedObject = newObj; // 새로 생성된 객체 선택

            Debug.Log($"로드 완료: {fbxFileNames[index]} - 선택된 객체: {selectedObject.name}");
            Debug.Log($"현재 총 객체 수: {spawnedObjects.Count}");
        }
        else
        {
            Debug.LogError($"파일을 찾을 수 없습니다: {fbxFileNames[index]}");
        }
    }


    // 새 객체 생성
    void SpawnNewObject()
    {
        LoadObject(currentObjectIndex);
    }

    // === 플러터로부터 가구 데이터를 받아 처리하는 함수 ===
    public void ReceiveFurnitureDataFromFlutter(FlutterUnityIntegration.MessageHandler handler)
    {
        // try
        // {
        //     // MessageHandler를 통해 FurnitureMessageData를 역직렬화
        //     FurnitureMessageData data = handler.getData<FurnitureMessageData>();

        //     if (data != null && !string.IsNullOrEmpty(data.filename) && data.position != null)
        //     {
        //         // GLB 파일은 유니티에서 Prefab으로 임포트되어 있어야 합니다.
        //         // Resources 폴더에 해당 Prefab이 있다고 가정하고 로드합니다.
        //         LoadObject(data.filename, data.position.ToVector3());
        //         Debug.Log($"플러터에서 가구 데이터 수신: 파일명={data.filename}, 위치={data.position.ToVector3()}");
        //         handler.send("Furniture loaded successfully!"); // 플러터로 성공 응답
        //     }
        //     else
        //     {
        //         Debug.LogError("플러터로부터 받은 가구 데이터가 유효하지 않습니다.");
        //         handler.send("Error: Invalid furniture data received."); // 플러터로 오류 응답
        //     }
        // }
        // catch (System.Exception e)
        // {
        //     Debug.LogError($"플러터 메시지 처리 중 오류 발생: {e.Message}");
        //     handler.send($"Error processing message: {e.Message}"); // 플러터로 오류 응답
        // }
    }

    // 마우스 위치의 객체 선택
    void SelectObjectUnderMouse()
    {
        Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
        Debug.Log($"레이캐스트 시도: {ray.origin} -> {ray.direction}");

        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            Debug.Log($"히트된 객체: {hit.collider.gameObject.name}");

            // 히트된 객체가 생성된 객체 목록에 있는지 확인
            if (spawnedObjects.Contains(hit.collider.gameObject))
            {
                selectedObject = hit.collider.gameObject;
                Debug.Log($"선택된 객체: {selectedObject.name}");
            }
            else
            {
                Debug.Log($"히트된 객체가 목록에 없음");
            }
        }
        else
        {
            Debug.Log("레이캐스트 히트 없음");
            selectedObject = null;
        }
    }

    // 드래그 시작
    void StartDrag()
    {
        if (selectedObject == null) return;

        Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            if (hit.collider.gameObject == selectedObject)
            {
                isDragging = true;
                // 더 안정적인 드래그를 위한 스크린 좌표 기반 계산
                Vector3 screenPos = mainCamera.WorldToScreenPoint(selectedObject.transform.position);
                dragOffset = selectedObject.transform.position - mainCamera.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, screenPos.z));
                Debug.Log($"드래그 시작: {selectedObject.name}, 오프셋: {dragOffset}");
            }
            else
            {
                Debug.Log($"드래그 시작 실패: 히트 객체 {hit.collider.gameObject.name}는 선택된 객체가 아님");
            }
        }
        else
        {
            Debug.Log("드래그 시작 실패: 레이캐스트 히트 없음");
        }
    }

    // 선택된 객체 드래그
    void DragSelectedObject()
    {
        if (!isDragging || selectedObject == null) return;

        // 스크린 좌표 기반 드래그 (더 안정적)
        Vector3 screenPos = mainCamera.WorldToScreenPoint(selectedObject.transform.position);
        Vector3 currentScreenPos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, screenPos.z);
        Vector3 worldPos = mainCamera.ScreenToWorldPoint(currentScreenPos);

        // Y축은 고정하고 X, Z축만 이동
        Vector3 newPosition = worldPos + dragOffset;
        selectedObject.transform.position = new Vector3(newPosition.x, selectedObject.transform.position.y, newPosition.z);
    }

    // 드래그 종료
    void EndDrag()
    {
        isDragging = false;
        if (selectedObject != null)
        {
            Debug.Log($"드래그 종료: {selectedObject.name} - 최종 위치: {selectedObject.transform.position}");
        }
    }

    // 선택된 객체 삭제
    void DeleteSelectedObject()
    {
        if (selectedObject != null && spawnedObjects.Contains(selectedObject))
        {
            spawnedObjects.Remove(selectedObject);
            Debug.Log($"객체 삭제: {selectedObject.name}");
            DestroyImmediate(selectedObject);
            selectedObject = null;
        }
    }

    // 모든 객체 제거
    [ContextMenu("모든 객체 제거")]
    public void ClearAllObjects()
    {
        foreach (GameObject obj in spawnedObjects)
        {
            if (obj != null)
            {
                DestroyImmediate(obj);
            }
        }
        spawnedObjects.Clear();
        selectedObject = null;
        Debug.Log("모든 객체 제거 완료");
    }

    // UI 표시
    private void OnGUI()
    {
        GUI.Label(new Rect(20, 35, 280, 20), $"현재 객체: {(selectedObject ? selectedObject.name : "없음")}");
        GUI.Label(new Rect(20, 55, 280, 20), $"컨트롤 모드: {currentMode}");
        GUI.Label(new Rect(20, 75, 280, 20), $"총 객체 수: {spawnedObjects.Count}");
        GUI.Label(new Rect(20, 95, 280, 20), $"드래그 상태: {(isDragging ? "드래그 중" : "대기")}");

        // 컨트롤 가이드
        GUI.Label(new Rect(20, 120, 280, 20), "컨트롤:");
        if (currentMode == ControlMode.Camera)
        {
            GUI.Label(new Rect(20, 170, 280, 20), "• 우클릭+마우스: 카메라 회전");
            GUI.Label(new Rect(20, 185, 280, 20), "• 스크롤: 줌");
        }
        else
        {
            GUI.Label(new Rect(20, 155, 280, 20), "• 마우스 클릭: 선택");
            GUI.Label(new Rect(20, 170, 280, 20), "• 마우스 드래그: 이동");
        }

        // 모드 변경 버튼
        if (GUI.Button(new Rect(320, 10, 80, 30), "이동 모드"))
        {
            currentMode = ControlMode.Move;
            Debug.Log("이동 모드로 변경");
        }
        if (GUI.Button(new Rect(320, 45, 80, 30), "사이즈 모드"))
        {
            currentMode = ControlMode.Size;
            Debug.Log("사이즈 모드로 변경");
        }
        if (GUI.Button(new Rect(320, 80, 80, 30), "회전 모드"))
        {
            currentMode = ControlMode.Rotate;
            Debug.Log("회전 모드로 변경");
        }
        if (GUI.Button(new Rect(320, 120, 80, 30), "카메라 모드"))
        {
            currentMode = ControlMode.Camera;
            Debug.Log("카메라 모드로 변경");
        }

        // 액션 버튼
        if (GUI.Button(new Rect(320, 160, 80, 30), "새 객체"))
        {
            SpawnNewObject();
        }
        if (GUI.Button(new Rect(320, 200, 80, 30), "우클릭 삭제"))
        {
            DeleteSelectedObject();
        }
        if (GUI.Button(new Rect(320, 230, 80, 30), "모두 삭제"))
        {
            ClearAllObjects();
        }

        // 상태 표시
        if (selectedObject != null)
        {
            GUI.Box(new Rect(10, 220, 300, 80), "선택된 객체 정보");
            GUI.Label(new Rect(20, 245, 280, 20), $"위치: {selectedObject.transform.position}");
            GUI.Label(new Rect(20, 265, 280, 20), $"회전: {selectedObject.transform.eulerAngles}");
        }

        // 카메라 정보
        if (currentMode == ControlMode.Camera)
        {
            GUI.Box(new Rect(10, 310, 300, 60), "카메라 정보");
            GUI.Label(new Rect(20, 335, 280, 20), $"위치: {mainCamera.transform.position}");
            GUI.Label(new Rect(20, 355, 280, 20), $"회전: {mainCamera.transform.eulerAngles}");
        }
    }
}
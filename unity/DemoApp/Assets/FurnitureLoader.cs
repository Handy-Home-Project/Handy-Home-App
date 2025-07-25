using System;
using System.Collections.Generic;
using FlutterUnityIntegration;
using Newtonsoft.Json;
using UnityEngine;

[System.Serializable]
public class FurnitureData
{
    public string fileName;
    public string name;
    public Position position;
    public float rotation;
}

[System.Serializable]
public class Position
{
    public float x;
    public float z;
}

public class FurnitureLoader : MonoBehaviour
{
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
        Camera // 카메라 모드 추가
    }

    private ControlMode currentMode = ControlMode.Move;

    void Start()
    {
        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }
    }


    void OnEnable()
    {
        // UnityMessageManager가 존재하고, OnFlutterMessage 이벤트에 구독합니다.
        if (UnityMessageManager.Instance != null)
        {
            UnityMessageManager.Instance.OnFlutterMessage += CreateFurnitureFromJson;
            Debug.Log("RoomDataParser: UnityMessageManager.OnFlutterMessage 이벤트에 구독했습니다.");
        }
        else
        {
            Debug.LogError("RoomDataParser: UnityMessageManager 인스턴스를 찾을 수 없습니다. Flutter 메시지 수신 불가.");
        }
    }

    void OnDisable()
    {
        // 스크립트가 비활성화될 때 이벤트 구독을 해제합니다.
        if (UnityMessageManager.Instance != null)
        {
            UnityMessageManager.Instance.OnFlutterMessage -= CreateFurnitureFromJson;
            Debug.Log("RoomDataParser: UnityMessageManager.OnFlutterMessage 이벤트 구독을 해제했습니다.");
        }
    }


    public void CreateFurnitureFromJson(MessageHandler handler)
    {
        String furnitureJsonData =  handler.getData<string>();
        
        if (string.IsNullOrEmpty(furnitureJsonData))
        {
            Debug.LogWarning("가구 JSON 데이터가 비어있음");
            return;
        }

        List<FurnitureData> furnitureList = null;
        try
        {
            furnitureList = JsonConvert.DeserializeObject<List<FurnitureData>>(furnitureJsonData);
        }
        catch (Exception e)
        {
            Debug.LogError($"가구 JSON 파싱 실패: {e.Message}");
            return;
        }

        foreach (var furniture in furnitureList)
        {
            if (string.IsNullOrEmpty(furniture.fileName))
            {
                Debug.LogWarning($"파일명이 빈 가구 데이터는 무시: {furniture.name}");
                continue;
            }

            GameObject prefab = Resources.Load<GameObject>(furniture.fileName);
            if (prefab == null)
            {
                Debug.LogWarning($"Resources에서 프리팹 못 찾음: {furniture.fileName}");
                continue;
            }

            GameObject newObj = Instantiate(prefab);
            newObj.transform.position = new Vector3(furniture.position.x, 0f, furniture.position.z);
            newObj.transform.rotation = Quaternion.Euler(0f, furniture.rotation, 0f);
            newObj.name = furniture.name;

            // Collider가 없으면 기본 BoxCollider 추가 (선택 사항)
            if (newObj.GetComponent<Collider>() == null)
            {
                var renderers = newObj.GetComponentsInChildren<Renderer>();
                if (renderers.Length > 0)
                {
                    Bounds combinedBounds = renderers[0].bounds;
                    foreach (var r in renderers)
                        combinedBounds.Encapsulate(r.bounds);

                    BoxCollider collider = newObj.AddComponent<BoxCollider>();
                    collider.center = newObj.transform.InverseTransformPoint(combinedBounds.center);
                    collider.size = combinedBounds.size;
                }
                else
                {
                    newObj.AddComponent<BoxCollider>().size = Vector3.one;
                }
            }

            spawnedObjects.Add(newObj);
        }

        Debug.Log($"총 {spawnedObjects.Count} 개 가구 생성 완료");
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


    // pub

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
                dragOffset = selectedObject.transform.position -
                             mainCamera.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y,
                                 screenPos.z));
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
        selectedObject.transform.position =
            new Vector3(newPosition.x, selectedObject.transform.position.y, newPosition.z);
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
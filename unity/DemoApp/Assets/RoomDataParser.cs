using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;
using System.Linq;
using FlutterUnityIntegration;

namespace DefaultNamespace
{
    // JSON 파싱을 처리하는 매니저 클래스
    public class RoomDataParser : MonoBehaviour
    {
        public Color defaultWallColor = new Color(0.9f, 0.9f, 0.9f); // 밝은 회색
        public Color defaultFloorColor = new Color(0.6f, 0.4f, 0.2f);
        public float wallThickness = 0.1f;

        // 가구 프리팹을 Inspector에서 할당할 수 있도록 하는 구조체와 리스트
        [System.Serializable]
        public class FurniturePrefabEntry
        {
            public string furnitureName; // JSON의 "furniture_name"과 일치해야 합니다.
            public GameObject prefab;    // 해당 가구의 Unity 프리팹을 여기에 할당하세요.
        }
        public List<FurniturePrefabEntry> furniturePrefabs; // Unity Inspector에서 여기에 프리팹들을 할당합니다.

        // 런타임에 프리팹을 빠르게 찾기 위한 딕셔너리
        private Dictionary<string, GameObject> _furniturePrefabMap;

        private List<GameObject> generatedObjects = new List<GameObject>(); // 방과 가구를 모두 추적


        [Header("JSON 데이터")]
        [TextArea(5, 10)]
        public string jsonData;

        private List<GameObject> generatedRooms = new List<GameObject>();
        private List<RoomData> rooms;

        void OnEnable()
        {
            // UnityMessageManager가 존재하고, OnFlutterMessage 이벤트에 구독합니다.
            if (UnityMessageManager.Instance != null)
            {
                UnityMessageManager.Instance.OnFlutterMessage += HandleFlutterMessage;
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
                UnityMessageManager.Instance.OnFlutterMessage -= HandleFlutterMessage;
                Debug.Log("RoomDataParser: UnityMessageManager.OnFlutterMessage 이벤트 구독을 해제했습니다.");
            }
        }

        /// <summary>
        /// Flutter로부터 메시지를 수신했을 때 호출되는 콜백 함수.
        /// </summary>
        /// <param name="handler">Flutter에서 보낸 메시지 데이터가 담긴 MessageHandler 객체</param>
        private void HandleFlutterMessage(MessageHandler handler)
        {
            Debug.Log($"RoomDataParser: Flutter로부터 메시지 수신 - Name: {handler.name}, ID: {handler.id}, Seq: {handler.seq}");

            // "LoadRoomData"라는 이름의 메시지가 오면 JSON 데이터를 파싱합니다.
            if (handler.name == "ParseRoomData")
            {
                try
                {
                    // MessageHandler의 getData<T>()를 사용하여 JSON 문자열을 가져옵니다.
                    string roomJsonData = handler.getData<string>();
                    Debug.Log($"RoomDataParser: 'LoadRoomData' 메시지 수신. JSON 데이터: {roomJsonData.Substring(0, Mathf.Min(roomJsonData.Length, 200))}..."); // 긴 문자열은 일부만 표시

                    ClearGeneratedObjects(); // 기존에 생성된 오브젝트들을 모두 제거
                    ParseRoomData(roomJsonData); // 수신한 JSON 데이터로 방을 파싱합니다.

                    // Flutter로 처리 완료 메시지를 보낼 수도 있습니다 (선택 사항)
                    // handler.send("Room data loaded successfully in Unity!"); 
                }
                catch (System.Exception e)
                {
                    Debug.LogError($"RoomDataParser: Flutter 메시지 처리 중 오류 발생: {e.Message}");
                    // Flutter로 오류 메시지를 보낼 수도 있습니다.
                    // handler.send($"Error loading room data: {e.Message}");
                }
            }
            else if (handler.name == "SpawnFurniture")
            {
                try
                {
                    string furnitureJsonData = handler.getData<string>();
                    Debug.Log($"RoomDataParser: 'SpawnFurniture' 메시지 수신. JSON 데이터: {furnitureJsonData.Substring(0, Mathf.Min(furnitureJsonData.Length, 200))}...");

                    // 가구만 지우고 싶다면 ClearGeneratedFurniture() 함수를 별도로 만들어서 호출
                    // ClearGeneratedObjects()를 호출하면 방도 같이 지워지니 주의
                    SpawnFurniture(furnitureJsonData);
                }
                catch (System.Exception e)
                {
                    Debug.LogError($"RoomDataParser: Flutter 메시지 처리 중 오류 발생 (SpawnFurniture): {e.Message}");
                }
            }
            else if (handler.name == "ClearRooms")
            {
                Debug.Log("RoomDataParser: 'ClearRooms' 메시지 수신.");
                ClearGeneratedObjects();
                // handler.send("Rooms cleared in Unity!");
            }
            // 다른 종류의 메시지도 여기에 추가할 수 있습니다.
            // else 
            // {
            //     Debug.LogWarning($"RoomDataParser: 알 수 없는 Flutter 메시지 이름: {handler.name}");
            // }
        }

        // 생성된 모든 GameObject를 안전하게 제거하는 내부 함수
        private void ClearGeneratedObjects()
        {
            foreach (GameObject obj in generatedRooms)
            {
                if (obj != null)
                {
                    DestroyImmediate(obj); // 에디터 모드에서는 DestroyImmediate를 사용해야 즉시 제거됩니다.
                }
            }
            generatedRooms.Clear(); // 리스트 비우기
            Debug.Log("RoomDataParser: 모든 생성된 오브젝트 제거 완료.");
        }

        void Awake()
        {
            // 런타임 시작 시 프리팹 딕셔너리를 초기화합니다.
            _furniturePrefabMap = new Dictionary<string, GameObject>();
            if (furniturePrefabs != null)
            {
                foreach (var entry in furniturePrefabs)
                {
                    if (!string.IsNullOrEmpty(entry.furnitureName) && entry.prefab != null)
                    {
                        if (!_furniturePrefabMap.ContainsKey(entry.furnitureName))
                        {
                            _furniturePrefabMap.Add(entry.furnitureName, entry.prefab);
                        }
                        else
                        {
                            Debug.LogWarning($"RoomDataParser: 중복된 가구 이름 '{entry.furnitureName}'이 프리팹 리스트에 있습니다. 건너뜜니다.");
                        }
                    }
                }
            }
        }

        void Start()
        {
            //JSON 문자열이 있으면 파싱
            // if (!string.IsNullOrEmpty(jsonData))
            // {
            //     ParseRoomData(jsonData);
            // }
        }

        public void ParseRoomData(string json)
        {
            try
            {
                // JSON 배열을 객체로 감싸기
                string wrappedJson = "{\"rooms\":" + json + "}";

                // JSON 파싱
                RoomDataList roomList = JsonConvert.DeserializeObject<RoomDataList>(wrappedJson);
                rooms = roomList.rooms;

                // 파싱된 데이터 출력
                foreach (RoomData room in rooms)
                {
                    Debug.Log($"Room: {room.name}, Type: {room.type}");
                    Debug.Log($"Vertices Count: {room.vertexes.Count}");

                    // 각 정점 출력
                    Vector2[] vertices = room.GetVertexes();
                    for (int i = 0; i < vertices.Length; i++)
                    {
                        Debug.Log($"  Vertex {i}: ({vertices[i].x}, {vertices[i].y})");
                    }
                }

                // 3D 오브젝트 생성 (선택사항)
                CreateRoomObjects();
            }
            catch (System.Exception e)
            {
                Debug.LogError($"JSON 파싱 실패: {e.Message}");
            }
        }

        // 파싱된 데이터로 3D 오브젝트 생성
        void CreateRoomObjects()
        {
            if (rooms == null) return;

            foreach (RoomData room in rooms)
            {
                CreateRoomObject(room);
            }
        }

        void CreateRoomObject(RoomData room)
        {
            // 방 부모 오브젝트 생성
            GameObject roomParent = new GameObject($"Room_{room.name}");
            roomParent.transform.SetParent(transform);
            generatedRooms.Add(roomParent);

            // 2D 좌표를 Vector3로 변환
            List<Vector3> vertices = new List<Vector3>();
            foreach (var vertex in room.vertexes)
            {
                if (vertex.Count >= 2)
                {
                    vertices.Add(new Vector3(vertex[0], 0, vertex[1]));
                }
            }

            // 바닥 생성
            CreateFloor(roomParent, vertices, room.name, room.type);

            // 벽 생성
            CreateWalls(roomParent, vertices, room.name, room.type);

            Debug.Log($"방 '{room.name}' 생성 완료");
        }

        private void CreateFloor(GameObject parent, List<Vector3> vertices, string roomName, string roomType)
        {
            GameObject floor = new GameObject($"Floor_{roomName}");
            floor.transform.SetParent(parent.transform);

            MeshRenderer renderer = floor.AddComponent<MeshRenderer>();
            MeshFilter filter = floor.AddComponent<MeshFilter>();

            Mesh mesh = CreatePolygonMesh(vertices, false);
            filter.mesh = mesh;

            // 방 타입에 따른 바닥 색상 설정
            Color floorColor = GetFloorColor(roomType);
            renderer.material = CreateColorMaterial(floorColor);

            // 바닥 콜라이더 추가
            MeshCollider collider = floor.AddComponent<MeshCollider>();
            collider.sharedMesh = mesh;

            Debug.Log($"바닥 생성됨: {roomName} ({roomType}), 색상: {floorColor}");
        }

        private void CreateWalls(GameObject parent, List<Vector3> vertices, string roomName, string roomType)
        {
            GameObject wallsParent = new GameObject($"Walls_{roomName}");
            wallsParent.transform.SetParent(parent.transform);

            Debug.Log($"벽 생성 시작: {roomName} ({roomType}), 버텍스 수: {vertices.Count}");

            for (int i = 0; i < vertices.Count; i++)
            {
                Vector3 current = vertices[i];
                Vector3 next = vertices[(i + 1) % vertices.Count];

                // 같은 점이면 벽을 생성하지 않음
                if (Vector3.Distance(current, next) < 0.01f)
                {
                    Debug.Log($"점이 너무 가까워 벽 생성 생략: {i}");
                    continue;
                }

                CreateWall(wallsParent, current, next, i, roomName, roomType);
            }
        }

        private void CreateWall(GameObject parent, Vector3 start, Vector3 end, int index, string roomName, string roomType)
        {
            GameObject wall = new GameObject($"Wall_{roomName}_{index}");
            wall.transform.SetParent(parent.transform);

            MeshRenderer renderer = wall.AddComponent<MeshRenderer>();
            MeshFilter filter = wall.AddComponent<MeshFilter>();

            // 벽 메쉬 생성
            Mesh mesh = CreateWallMesh(start, end);
            filter.mesh = mesh;

            // 방 타입에 따른 벽 색상 설정
            Color wallColor = GetWallColor(roomType);
            renderer.material = CreateColorMaterial(wallColor);

            // 벽 콜라이더 추가
            MeshCollider collider = wall.AddComponent<MeshCollider>();
            collider.sharedMesh = mesh;

            Debug.Log($"벽 생성됨: {roomName}_{index} ({roomType}), 색상: {wallColor}");
        }

        private Mesh CreateWallMesh(Vector3 start, Vector3 end)
        {

            float roomHeight = 5f;
            float wallThickness = 0.1234f;

            Vector3 direction = (end - start).normalized;
            Vector3 thicknessDir = Vector3.Cross(Vector3.up, direction); // 방 내부 방향으로만

            // 한쪽만 두께 적용 (벽이 바깥으로는 안 삐져나오게!)
            Vector3 offset = thicknessDir * wallThickness;

            Vector3 p0 = start;
            Vector3 p1 = end;
            Vector3 p2 = end + offset + Vector3.up * roomHeight;
            Vector3 p3 = start + offset + Vector3.up * roomHeight;
            Vector3 p4 = start + offset;
            Vector3 p5 = end + offset;
            Vector3 p6 = end + Vector3.up * roomHeight;
            Vector3 p7 = start + Vector3.up * roomHeight;

            Vector3[] vertices = { p0, p1, p5, p4, p7, p6, p2, p3 };

            int[] triangles = {
            // 앞면
            0,1,5, 0,5,4,
            // 오른쪽면
            1,2,6, 1,6,5,
            // 뒷면
            2,3,7, 2,7,6,
            // 왼쪽면
            3,0,4, 3,4,7,
            // 윗면
            4,5,6, 4,6,7,
            // 아랫면
            0,2,1, 0,3,2
        };

            Vector2[] uv = new Vector2[8];
            for (int i = 0; i < 8; i++)
                uv[i] = new Vector2(vertices[i].x, vertices[i].y);

            Mesh mesh = new Mesh();
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = uv;
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();

            return mesh;
        }

        private Mesh CreatePolygonMesh(List<Vector3> vertices, bool flipNormals = false)
        {
            Mesh mesh = new Mesh();

            // 삼각분할 (간단한 fan triangulation)
            List<int> triangles = new List<int>();
            for (int i = 1; i < vertices.Count - 1; i++)
            {
                if (flipNormals)
                {
                    triangles.Add(0);
                    triangles.Add(i + 1);
                    triangles.Add(i);
                }
                else
                {
                    triangles.Add(0);
                    triangles.Add(i);
                    triangles.Add(i + 1);
                }
            }

            // UV 좌표 생성
            Vector2[] uv = new Vector2[vertices.Count];
            Bounds bounds = new Bounds(vertices[0], Vector3.zero);
            foreach (Vector3 vertex in vertices)
            {
                bounds.Encapsulate(vertex);
            }

            for (int i = 0; i < vertices.Count; i++)
            {
                uv[i] = new Vector2(
                    (vertices[i].x - bounds.min.x) / bounds.size.x,
                    (vertices[i].z - bounds.min.z) / bounds.size.z
                );
            }

            mesh.vertices = vertices.ToArray();
            mesh.triangles = triangles.ToArray();
            mesh.uv = uv;
            mesh.RecalculateNormals();

            return mesh;
        }

        private void ClearGeneratedRooms()
        {
            foreach (GameObject room in generatedRooms)
            {
                if (room != null)
                {
                    DestroyImmediate(room);
                }
            }
            generatedRooms.Clear();
        }

        [ContextMenu("Generate Test Rooms")]
        public void GenerateTestRooms()
        {
            Start();
        }

        [ContextMenu("Clear Rooms")]
        public void ClearRooms()
        {
            ClearGeneratedRooms();
        }

        // 기본 머티리얼 생성 헬퍼 함수
        private Material CreateColorMaterial(Color color)
        {
            Shader s = Shader.Find("Universal Render Pipeline/Lit");
            var mat = new Material(s);
            mat.SetColor("_BaseColor", color); // 원하는 색상 지정
            return mat;
        }

        // 방 타입에 따른 바닥 색상 반환
        private Color GetFloorColor(string roomType)
        {
            return defaultFloorColor;
        }

        // 방 타입에 따른 벽 색상 반환
        private Color GetWallColor(string roomType)
        {
            return defaultWallColor;
        }
    
        /// <summary>
        /// JSON 문자열을 파싱하여 가구를 스폰합니다.
        /// </summary>
        public void SpawnFurniture(string jsonText)
        {
            if (string.IsNullOrEmpty(jsonText))
            {
                Debug.LogError("RoomDataParser: 스폰할 가구 JSON 데이터가 비어있습니다.");
                return;
            }

            FurnitureDataList furnitureList;
            try
            {
                // JSON 배열을 "furniture" 키로 감싸서 FurnitureDataList로 파싱합니다.
                string wrappedJson = "{\"furniture\":" + jsonText + "}";
                furnitureList = JsonConvert.DeserializeObject<FurnitureDataList>(wrappedJson);
            }
            catch (System.Exception e)
            {
                Debug.LogError($"RoomDataParser: 가구 JSON 데이터를 파싱하는 데 실패했습니다: {e.Message}");
                return;
            }

            if (furnitureList?.furniture == null || furnitureList.furniture.Count == 0)
            {
                Debug.LogWarning("RoomDataParser: JSON 데이터에서 가구 정보를 찾을 수 없습니다.");
                return;
            }

            // 가구를 담을 부모 GameObject 생성 (정리 용이)
            GameObject furnitureContainer = new GameObject("GeneratedFurniture");
            furnitureContainer.transform.position = Vector3.zero;
            generatedObjects.Add(furnitureContainer); // 생성된 오브젝트 리스트에 추가

            foreach (FurnitureData furniture in furnitureList.furniture)
            {
                if (furniture == null) continue;

                // 좌표 데이터 유효성 검사 (최소 x, z 두 값 필요)
                if (furniture.coordinate == null || furniture.coordinate.Count < 2)
                {
                    Debug.LogWarning($"RoomDataParser: 가구 '{furniture.furniture_name}'의 좌표 데이터가 유효하지 않습니다. [x,z] 형태여야 합니다. 스폰하지 않습니다.");
                    continue;
                }

                GameObject prefabToSpawn = null;

                // Inspector에서 할당된 딕셔너리에서 프리팹을 찾습니다.
                if (_furniturePrefabMap.ContainsKey(furniture.furniture_name))
                {
                    prefabToSpawn = _furniturePrefabMap[furniture.furniture_name];
                }
                else
                {
                    // 프리팹이 딕셔너리에 없다면 Resources 폴더에서 로드 시도
                    // 예: Resources/Furniture/Chair.prefab
                    // 이 방법을 사용하려면 해당 이름의 프리팹이 'Assets/Resources/Furniture/' 경로에 있어야 합니다.
                    prefabToSpawn = Resources.Load<GameObject>($"Furniture/{furniture.furniture_name}");
                    if (prefabToSpawn != null)
                    {
                        Debug.Log($"RoomDataParser: Resources 폴더에서 '{furniture.furniture_name}' 프리팹을 로드했습니다.");
                    }
                }
                
                if (prefabToSpawn == null)
                {
                    Debug.LogWarning($"RoomDataParser: 가구 '{furniture.furniture_name}'에 해당하는 프리팹을 찾을 수 없습니다. (Inspector 할당 또는 Resources/Furniture/{furniture.furniture_name} 확인 필요) 스폰하지 않습니다.");
                    continue;
                }

                // 가구 위치 및 회전 설정
                // XZ 평면 좌표를 Unity의 Vector3로 변환 (Y 좌표는 0으로 기본 설정, 필요에 따라 조절)
                // coordinate[0]은 X, coordinate[1]은 Z
                Vector3 spawnPosition = new Vector3(furniture.coordinate[0], 0f, furniture.coordinate[1]);
                Quaternion spawnRotation = Quaternion.Euler(0, furniture.rotate, 0); // Y축 회전

                GameObject spawnedFurniture = Instantiate(prefabToSpawn, spawnPosition, spawnRotation);
                spawnedFurniture.name = $"{furniture.furniture_name}_Spawned";
                spawnedFurniture.transform.parent = furnitureContainer.transform; // 부모 오브젝트에 추가
                generatedObjects.Add(spawnedFurniture); // 생성된 오브젝트 리스트에 추가

                spawnedFurniture.transform.localScale = new Vector3(0.025f, 0.025f, 0.025f);


                Debug.Log($"RoomDataParser: 가구 '{furniture.furniture_name}' (위치: {spawnPosition}, 회전: {spawnRotation.eulerAngles}) 스폰 완료.");
            }
            Debug.Log("RoomDataParser: 모든 가구 스폰이 완료되었습니다.");
        }
    
    
}
}
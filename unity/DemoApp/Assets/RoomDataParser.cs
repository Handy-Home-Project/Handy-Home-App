
using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;

namespace DefaultNamespace
{
    // JSON 파싱을 처리하는 매니저 클래스
public class RoomDataParser : MonoBehaviour
{
    public Color defaultWallColor = new Color(0.9f, 0.9f, 0.9f); // 밝은 회색
    public Color defaultFloorColor = new Color(0.6f, 0.4f, 0.2f);
    
    
    [Header("JSON 데이터")]
    [TextArea(5, 10)]
    public string jsonData;
    
    private List<GameObject> generatedRooms = new List<GameObject>();
    private List<RoomData> rooms;
    
    void Start()
    {
        // JSON 문자열이 있으면 파싱
        if (!string.IsNullOrEmpty(jsonData))
        {
            ParseRoomData(jsonData);
        }
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
        for(int i=0; i<8; i++)
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
    
}
}
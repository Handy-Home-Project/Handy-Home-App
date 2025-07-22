using System.Collections.Generic;
using UnityEngine;


namespace DefaultNamespace
{
    
    [System.Serializable]
    public class RoomData
    {
        public string name;
        public List<List<float>> vertexes;
        public string type;
    
        // 편의를 위한 Vector2 배열 반환
        public Vector2[] GetVertexes()
        {
            Vector2[] vertices = new Vector2[vertexes.Count];
            for (int i = 0; i < vertexes.Count; i++)
            {
                if (vertexes[i].Count >= 2)
                {
                    vertices[i] = new Vector2(vertexes[i][0], vertexes[i][1]);
                }
            }
            return vertices;
        }
    }
    
    [System.Serializable]
    public class RoomDataList
    {
        public List<RoomData> rooms;
    }
    
}
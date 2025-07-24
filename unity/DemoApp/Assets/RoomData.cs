using System;
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

    // 가구 하나의 정보를 담는 클래스
    [System.Serializable]
    public class FurnitureData
    {
        public string furniture_name;
        public List<float> coordinate; // [x, z] 좌표를 List<float>로 받음
        public float rotate; // Y축 회전 값 (도 단위)
    }
    
    // 여러 가구 정보를 담는 리스트를 위한 래퍼 클래스
    [System.Serializable]
    public class FurnitureDataList
    {
        public List<FurnitureData> furniture;
    }
    
}
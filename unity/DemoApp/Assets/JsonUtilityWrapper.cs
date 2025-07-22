using System;
using System.Collections.Generic;
using UnityEngine;

namespace DefaultNamespace
{
    public static class JsonUtilityWrapper
    {
        [Serializable]
        private class Wrapper<T>
        {
            public List<T> Items;
        }

        public static List<T> FromJsonList<T>(string json)
        {
            string newJson = "{ \"Items\": " + json + "}";
            return JsonUtility.FromJson<Wrapper<T>>(newJson).Items;
        }
    }
}
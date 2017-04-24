﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VertexPositionStorage {

    [ExecuteInEditMode]
    public class VertexPositionBlender : MonoBehaviour {
        public string propVertexPosition = "_VertesPositions";
        public GameObject referenceObject;

        Storage capture;
        Renderer attachedRenderer;

        #region Unity
        void OnEnable() {
            capture = new Storage (referenceObject.GetComponentInChildren<SkinnedMeshRenderer> ());
            attachedRenderer = GetComponentInChildren<Renderer> ();
        }
        void Update() {
            capture.Capture (referenceObject.transform.localToWorldMatrix);
            attachedRenderer.sharedMaterial.SetBuffer (propVertexPosition, capture.GPUBuffer);
        }
        void OnDisable() {
            capture.Dispose ();
        }
        #endregion
    }

}
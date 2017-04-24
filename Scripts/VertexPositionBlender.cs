﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VertexPositionStorage {

    [ExecuteInEditMode]
    public class VertexPositionBlender : MonoBehaviour {
        public string propVertexPosition = "_VertexPositions";
        public GameObject referenceObject;
        public bool autoStartOnAwake = false;

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
            if (capture != null) {
                capture.Dispose ();
                capture = null;
            }
        }
        #endregion
    }

}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VertexPositionStorage {

    [ExecuteInEditMode]
    public class VertexPositionBlender : MonoBehaviour {
        public string propVertexPosition = "_VertexPositions";
        public GameObject referenceObject;
        public bool prescaled = false;

        Storage capture;
        Renderer attachedRenderer;

        #region Unity
        void OnEnable() {
            capture = new Storage (referenceObject.GetComponentInChildren<SkinnedMeshRenderer> ());
            attachedRenderer = GetComponentInChildren<Renderer> ();
        }
        void Update() {
            capture.CaptureWorld(prescaled);
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
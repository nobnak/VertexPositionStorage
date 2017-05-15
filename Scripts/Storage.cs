using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Gist;

namespace VertexPositionStorage {

    public class Storage : System.IDisposable {
        SkinnedMeshRenderer skin;
        GPUArray<Vector3> gpuVertexPositions;
        Mesh animatedMesh;

        public Storage(SkinnedMeshRenderer skin) {
            this.skin = skin;
            this.animatedMesh = new Mesh ();
            this.gpuVertexPositions = new GPUArray<Vector3> (skin.sharedMesh.vertexCount);
        }

        #region IDisposable implementation
        public void Dispose () {
            gpuVertexPositions.Dispose ();
            Release (ref animatedMesh);
        }
        #endregion

        public ComputeBuffer GPUBuffer {
            get { return gpuVertexPositions.GPUBuffer; }
        }
        public void Capture(Matrix4x4 m) {
            var vertices = CaptureVertices ();
            for (var i = 0; i < vertices.Length; i++)
                vertices [i] = m.MultiplyPoint3x4 (vertices [i]);
            ApplyVertices (vertices);
        }
        public void CaptureLocal() {
            Capture (Matrix4x4.identity);
        }
        public void CaptureWorld(bool preScaled = false) {
            if (skin == null)
                return;
            
            var m = skin.localToWorldMatrix;
            if (preScaled) {
                var scale = skin.transform.lossyScale;
                scale = new Vector3 (1f / scale.x, 1f / scale.y, 1f / scale.z);
                m *= Matrix4x4.Scale (scale);
            }
            Capture (m);
        }

        Vector3[] CaptureVertices() {
            skin.BakeMesh (animatedMesh);
            return animatedMesh.vertices;
        }
        void ApplyVertices(Vector3[] vertices) {
            System.Array.Copy (vertices, gpuVertexPositions.CPUBuffer, vertices.Length);
            gpuVertexPositions.Upload ();
        }
        void Release<T>(ref T obj) where T : Object {
            if (Application.isPlaying)
                Object.Destroy (obj);
            else
                Object.DestroyImmediate (obj);
            obj = null;
        }
    }
}

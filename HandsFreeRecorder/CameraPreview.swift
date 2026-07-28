import AVFoundation
import SwiftUI
import UIKit

/// A UIView whose backing layer *is* the preview layer, so it resizes with the
/// view for free.
final class PreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

    var previewLayer: AVCaptureVideoPreviewLayer {
        // Safe: layerClass above guarantees the type.
        layer as! AVCaptureVideoPreviewLayer
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        applyPortraitRotation(to: view)
        return view
    }

    // The connection may not exist yet on the first pass, so try again on update.
    func updateUIView(_ uiView: PreviewView, context: Context) {
        applyPortraitRotation(to: uiView)
    }

    private func applyPortraitRotation(to view: PreviewView) {
        guard let connection = view.previewLayer.connection,
              connection.isVideoRotationAngleSupported(90) else { return }
        connection.videoRotationAngle = 90
    }
}

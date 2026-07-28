import Photos

/// Copies finished clips into the Photos library, filed under a "CLIPS" album.
///
/// The app only ever asks for add-only access — it never needs to read the
/// user's existing photos.
actor PhotoLibrarySaver {

    static let shared = PhotoLibrarySaver()

    /// The Photos album clips are filed under. The UI reads this rather than
    /// hardcoding the name, so renaming the album is a one-line change.
    static let albumName = "CLIPS"

    enum SaveError: LocalizedError {
        case noAlbum

        var errorDescription: String? {
            switch self {
            case .noAlbum: return "Couldn't create the \(PhotoLibrarySaver.albumName) album in Photos."
            }
        }
    }

    private var cachedAlbum: PHAssetCollection?

    /// Add-only permission. `.limited` never comes back for add-only access,
    /// but treat it as usable if it ever does.
    static func requestAddAccess() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            return status == .authorized || status == .limited
        default:
            return false
        }
    }

    /// Copies the clip into Photos. Throws if the asset can't be created, in
    /// which case the caller should leave the original file alone.
    func save(videoAt url: URL) async throws {
        let album = try await albumCollection()

        try await PHPhotoLibrary.shared().performChanges {
            let creation = PHAssetCreationRequest.forAsset()
            creation.addResource(with: .video, fileURL: url, options: nil)

            if let placeholder = creation.placeholderForCreatedAsset,
               let addToAlbum = PHAssetCollectionChangeRequest(for: album) {
                addToAlbum.addAssets([placeholder] as NSArray)
            }
        }
    }

    // MARK: - Album

    private func albumCollection() async throws -> PHAssetCollection {
        if let cachedAlbum { return cachedAlbum }

        if let existing = Self.findAlbum() {
            cachedAlbum = existing
            return existing
        }

        var newIdentifier: String?
        try await PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest
                .creationRequestForAssetCollection(withTitle: Self.albumName)
            newIdentifier = request.placeholderForCreatedAssetCollection.localIdentifier
        }

        guard let newIdentifier,
              let created = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [newIdentifier], options: nil).firstObject
        else {
            throw SaveError.noAlbum
        }

        cachedAlbum = created
        return created
    }

    private static func findAlbum() -> PHAssetCollection? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        return PHAssetCollection.fetchAssetCollections(
            with: .album, subtype: .albumRegular, options: options).firstObject
    }
}

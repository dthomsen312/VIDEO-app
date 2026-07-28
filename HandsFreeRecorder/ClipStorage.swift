import Foundation

/// Everything to do with where clips live on disk and what they're called.
///
/// Clips go in `Documents/Recordings`. The app enables file sharing, so that
/// folder shows up in the Files app under "On My iPhone → VIDEO".
enum ClipStorage {

    static let folderName = "Recordings"

    static var folderURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(folderName, isDirectory: true)
    }

    private static let stampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()

    /// Creates the recordings folder if needed and returns a unique URL stamped
    /// with the current date and time, e.g. `Clip_2026-07-28_14-32-05.mov`.
    static func newClipURL(date: Date = Date()) throws -> URL {
        let folder = folderURL
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let stamp = stampFormatter.string(from: date)
        var candidate = folder.appendingPathComponent("Clip_\(stamp).mov")

        // Two clips can't normally land in the same second, but never overwrite.
        var suffix = 2
        while FileManager.default.fileExists(atPath: candidate.path) {
            candidate = folder.appendingPathComponent("Clip_\(stamp)-\(suffix).mov")
            suffix += 1
        }
        return candidate
    }

    /// Free space on the volume holding the clips, in bytes.
    static var availableBytes: Int64? {
        let values = try? folderURL.deletingLastPathComponent()
            .resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        return values?.volumeAvailableCapacityForImportantUsage
    }

    static func clipCount() -> Int {
        let contents = try? FileManager.default.contentsOfDirectory(
            at: folderURL, includingPropertiesForKeys: nil)
        return contents?.filter { $0.pathExtension.lowercased() == "mov" }.count ?? 0
    }
}

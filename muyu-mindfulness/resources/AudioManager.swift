import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    @Published var soundVolume: Double = UserDefaults.standard.double(forKey: "soundVolume") {
        didSet {
            UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
        }
    }

    func prepareSound() {
        let sourceName = "sound_2"
        let extensionName = "mp3"
        guard let soundURL = Bundle.main.url(forResource: sourceName, withExtension: extensionName) else {
            print("音频资源 \(sourceName).\(extensionName)未找到！")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = Float(soundVolume)
            print("将使用音频文件：\(sourceName).\(extensionName)")
        } catch {
            print("无法创建音频播放器: \(error.localizedDescription)")
        }
    }

    func playSound() {
        audioPlayer?.volume = Float(soundVolume)
        audioPlayer?.play()
    }
}

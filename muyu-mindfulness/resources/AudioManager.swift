import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var volume: Float = UserDefaults.standard.float(forKey: "soundVolume") {
        didSet {
            audioPlayer?.volume = volume
            UserDefaults.standard.set(volume, forKey: "soundVolume")
        }
    }
    
    init() {
        if volume == 0 {
            volume = 1.0 // 默认音量为最大
        }
        prepareSound()
    }
    
    func prepareSound() {
        let soundName = "sound_2"
        let soundExtension = "mp3"
        
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: soundExtension, subdirectory: "resources") ??
                             Bundle.main.url(forResource: soundName, withExtension: soundExtension) else {
            print("音频文件未找到：\(soundName).\(soundExtension)，文件路径：\(Bundle.main.bundlePath)/resources/\(soundName).\(soundExtension)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = volume
            print("成功加载音频文件：\(soundURL.lastPathComponent)")
        } catch {
            print("准备音频播放器时出错: \(error.localizedDescription)")
        }
    }
    
    func playSound() {
        guard let player = audioPlayer else {
            print("音频播放器未初始化")
            return
        }
        
        if player.play() {
//            print("开始播放音频")
        } else {
            print("播放音频失败")
        }
    }
    
    func resetToDefaults() {
        volume = 1.0 // 默认音量
        UserDefaults.standard.removeObject(forKey: "soundVolume")
    }
}

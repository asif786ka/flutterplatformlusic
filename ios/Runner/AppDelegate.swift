import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    // Declaring audio player
    var audioPlayer = AVAudioPlayer()

    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Defining the audio player
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:
                URL.init(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "mp3")!))
            audioPlayer.prepareToPlay()

            // Defining audio session for background playback
            let audioSession = AVAudioSession.sharedInstance()

            do {
                if #available(iOS 10.0, *) {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options:[])
                } else {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback, with:[])
                }
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }

        // Setting for infinite looping of audio
        audioPlayer.numberOfLoops = -1

        let controller = window?.rootViewController as! FlutterViewController

        // Method channel implementation
        let channel = FlutterMethodChannel(name:"music", binaryMessenger:controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void
            in
            guard call.method == "startMusic" || call.method == "stopMusic" else {
                result(FlutterMethodNotImplemented)
                return
            }
            if (call.method == "startMusic") {
                self.startMusic(result: result)
            }
            else if (call.method == "stopMusic") {
                self.stopMusic(result: result)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Starts music
    private func startMusic(result: FlutterResult) {
        audioPlayer.play()
        result(true)
    }

    // Stops music
    private func stopMusic(result: FlutterResult) {
        // Checking if audio player is playing the audio, if so, stopping it
        if (audioPlayer.isPlaying) {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        result(false)
    }
}
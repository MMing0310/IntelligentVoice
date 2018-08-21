//
//  ViewController.swift
//  IntelligentVoice
//
//  Created by dongmingming on 2018/8/17.
//  Copyright © 2018年 DongMingMing. All rights reserved.
//

import UIKit

/// 智能语音识别
import NlsSdk.NlsClientAdaptor
import NlsSdk.RecognizerRequestParam
import NlsSdk.NlsSpeechRecognizerRequest


class ViewController: UIViewController, UITextFieldDelegate, NlsSpeechRecognizerDelegate,NlsVoiceRecorderDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var topView: UIView!
    
    /// 语音按钮
    var voiceBtn = UIButton()
    // wave view
    let kscreen_width = UIScreen.main.bounds.size.width
    let kscreen_height = UIScreen.main.bounds.size.height
    
    var waveView = UIView()
    var voiceWaveView = YSCVoiceWaveView()
    
    /// 智能语音识别
    var nlsClient = NlsClientAdaptor()
    var recognizeRequest:NlsSpeechRecognizerRequest?
    var voiceRecorder = NlsVoiceRecorder()
    var recognizeRequestParam = RecognizerRequestParam()
    var recognizerStarted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configure()
        
        // 需要更换自己的token和appkey
        // self.voiceRecognition()
    }

    func configure() {
        
        //////  增加语音按钮
        voiceBtn.frame = CGRect(x: (kscreen_width - 96) / 2, y: kscreen_height - 96 - 49, width: 96, height: 96)
        voiceBtn.setImage(UIImage(named: "语音"), for: .normal)
        voiceBtn.addTarget(self, action: #selector(stopVoiceAction(_:)), for: .touchUpInside)
        voiceBtn.addTarget(self, action: #selector(startVoiceAction(_:)), for: .touchDown)
        self.view.addSubview(voiceBtn)
        
        self.topView.layer.borderWidth = 1
        self.topView.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
    /// 智能语音识别
    func voiceRecognition() {
        //1. 全局参数初始化操作
        //1.1 初始化识别客户端,将recognizerStarted状态置为false
        nlsClient = NlsClientAdaptor()
        recognizerStarted = false
        //1.2 初始化录音recorder工具
        voiceRecorder.delegate = self
        //1.3 初始化识别参数类
        recognizeRequestParam = RecognizerRequestParam()
        //1.4 设置log级别
        nlsClient.setLog(nil, logLevel: 1)
    }
    
    // 语音按钮点击事件
    // 开始录音
    @objc func startVoiceAction(_ sender: UIButton) {
        print("录音了。。。。。")
        self.searchTF.text = ""
        voiceWaveView.changeVolume(0.4)
        voiceWaveView.showParentView(waveView)
        voiceWaveView.startVoiceWave()
        
        // 需要更换自己的token和appkey
//        self.startRecognize()
    }
    
    // 结束录音
    @objc func stopVoiceAction(_ sender: UIButton) {
        print("录音结束了。。。。。")
        // 移除
        voiceWaveView.removeFromParent()
        //3 结束识别 停止录音，停止识别请求
//        voiceRecorder.stoprecorder(true)
//        recognizeRequest!.stop()
//        recognizerStarted = false;
    }
    
    ///////////// 智能语音识别 /////////////////////////////////
    func startRecognize() {
        //2. 创建请求对象和开始识别
        
        //2.1 创建请求对象，设置NlsSpeechRecognizerDelegate回调
        recognizeRequest = nlsClient.createRecognizerRequest()
        recognizeRequest!.delegate = self
        
        //2.2 设置RecognizerRequestParam请求参数
        recognizeRequestParam.format = "opu"
        recognizeRequestParam.enableIntermediateResult = true
        //请使用https://help.aliyun.com/document_detail/72153.html 动态生成token
        // <AccessKeyId> <AccessKeySecret> 请使用您的阿里云账户生成 https://ak-console.aliyun.com/
        recognizeRequestParam.token = "更换自己的token"
        recognizeRequestParam.appkey = "更换自己的appKey"
        
        //2.3 传入请求参数
        recognizeRequest!.setRecognizeParams(recognizeRequestParam)
        
        //2.4 启动录音和识别，将recognizerStarted置为true
        voiceRecorder.start(true)
        recognizeRequest!.start()
        recognizerStarted = true
        
        //2.5 更新UI
        DispatchQueue.main.async {
            print("主线程刷新你的UI操作")
        }
    }
    
    
    /**
     *4. NlsSpeechRecognizerDelegate回调方法
     */
    //4.1 识别回调，本次请求失败
    func onTaskFailed(_ event: NlsDelegateEvent, statusCode: String!, errorMessage eMsg: String!) {
        voiceRecorder.stoprecorder(true)
        print("OnTaskFailed, error message is: \(eMsg)")
    }
    
    //4.2 识别回调，服务端连接关闭
    func onChannelClosed(_ event: NlsDelegateEvent, statusCode: String!, errorMessage eMsg: String!) {
        voiceRecorder.stoprecorder(true)
        print("OnTaskFailed, error message is: \(statusCode)")
    }
    
    //4.3 识别回调，识别结果结束
    func onRecognizedCompleted(_ event: NlsDelegateEvent, result: String!, statusCode: String!, errorMessage eMsg: String!) {
        recognizerStarted = false
     
        // 主线程UI更新代码
        DispatchQueue.main.async {
            print("主线程刷新UI操作")
        }
    }
    
    //4.4 识别回调，识别中间结果
    func onRecognizedResultChanged(_ event: NlsDelegateEvent, result: String!, statusCode: String!, errorMessage eMsg: String!) {
        
    }
    
    
    /**
     *5. 录音相关回调
     */
    func recorderDidStart() {
        print("Did start recorder!")
        
    }
    
    func recorderDidStop() {
        print("Did stop recorder!")
        
    }
    
    
    func voiceDidFail(_ error: Error) {
        print("Did recorder error!")
    }
    
    //5.1 录音数据回调
    func voiceRecorded(_ frame: Data) {
        if (recognizerStarted) {
            //录音线程回调的数据传给识别服务
            recognizeRequest!.sendAudio(frame as Data, length: Int32(frame.count))
        }
    }
    
    ///////////////////////////////////////
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


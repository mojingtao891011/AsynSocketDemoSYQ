//
//  ServerViewController.m
//  AsynSocketDemo
//
//  Created by syq on 16/2/27.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ServerViewController.h"
#import "GCDAsyncSocket.h"
@interface ServerViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//服务器socket
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
//保存链接成功的客户端socket
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
//服务器监听
- (IBAction)listenAction:(id)sender;
//发送消息
- (IBAction)sendMessageAction:(id)sender;
//接收消息
- (IBAction)receiveMessageAction:(id)sender;
@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)listenAction:(id)sender {
    //1.创建服务器socket
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //2.开始监听（开放哪一个端口）
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portTF.text.integerValue error:&error];
    if (result) {
        //开放成功
        [self showTextViewWithText:@"开放监听成功"];
    }else{
        //开放失败
        [self showTextViewWithText:@"开放监听失败"];
    }
}
- (IBAction)sendMessageAction:(id)sender {
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    //发送信息
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}
- (IBAction)receiveMessageAction:(id)sender {
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
//展示消息
-(void)showTextViewWithText:(NSString *)text{
    self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n",text];
}
#pragma mark  socketdelegate
//监听到客户端socket链接
//当客户端链接成功后，生成一个新的客户端socket
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    [self showTextViewWithText:@"链接成功"];
    //connectedHost:地址IP
    //connectedPort:端口
    [self showTextViewWithText:[NSString stringWithFormat:@"链接地址:%@",newSocket.connectedHost]];
    //保存客户端socket
    self.clientSocket = newSocket;
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
//成功读取客户端发过来的消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showTextViewWithText:message];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [self showTextViewWithText:@"消息发送成功"];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end

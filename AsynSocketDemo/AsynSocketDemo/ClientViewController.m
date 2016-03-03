//
//  ClientViewController.m
//  AsynSocketDemo
//
//  Created by syq on 16/2/27.
//  Copyright © 2016年 lanou.syq. All rights reserved.
//

#import "ClientViewController.h"
#import "GCDAsyncSocket.h"

@interface ClientViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//客户端socket
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
//链接方法
- (IBAction)connectServerAction:(id)sender;
//发送消息
- (IBAction)sendMessage:(id)sender;
//接收消息
- (IBAction)receiveMessageAction:(id)sender;



@end

@implementation ClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)connectServerAction:(id)sender {
    //1.创建
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //2.链接服务器socket
    BOOL result = [self.clientSocket connectToHost:self.addressTF.text onPort:self.portTF.text.integerValue error:nil];
    //判断链接
    if (result) {
        //成功
        [self showTextViewWithText:@"链接成功"];
    }else{
        //失败
        [self showTextViewWithText:@"链接失败"];
    }
}

- (IBAction)sendMessage:(id)sender {
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
#pragma mark ------------
//客户端链接服务器成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self showTextViewWithText:[NSString stringWithFormat:@"链接成功服务器：%@",host]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [self showTextViewWithText:@"消息发送成功"];
}
//成功读取客户端发过来的消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showTextViewWithText:message];
    [self.clientSocket readDataWithTimeout:-1 tag:0];    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

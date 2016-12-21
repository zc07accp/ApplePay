//
//  ViewController.m
//  快捷键测试
//
//  Created by zf on 2016/12/19.
//  Copyright © 2016年 zf. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![PKPaymentAuthorizationViewController canMakePayments])
    {
        NSLog(@"不能支付");
    }
    else if(![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkMasterCard,PKPaymentNetworkChinaUnionPay]])
    {
        PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhite];
        [button addTarget:self action:@selector(touchAddCard) forControlEvents:UIControlEventTouchUpInside];
        button.frame =CGRectMake(100, 100, 100, 30);
        [self.view addSubview:button];
    }
    else
    {
        PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        [button addTarget:self action:@selector(touchPay) forControlEvents:UIControlEventTouchUpInside];
        button.frame =CGRectMake(100, 100, 100, 30);
        [self.view addSubview:button];
    }
}
-(void)touchAddCard
{
    PKPassLibrary *pl = [[PKPassLibrary alloc]init];
    
    [pl openPaymentSetup];
}
-(void)touchPay
{
    //创建支付请求
    PKPaymentRequest *pay = [[PKPaymentRequest alloc]init];
    
    pay.merchantIdentifier = @"merchant.ApplePayDemo.zhangfei";
    //配置
    pay.countryCode = @"CN";
    pay.currencyCode = @"CNY" ;
    pay.supportedNetworks = @[PKPaymentNetworkMasterCard,PKPaymentNetworkChinaUnionPay];
    pay.merchantCapabilities = PKMerchantCapability3DS;
    //配置购买商品
    NSDecimalNumber * decimalNumber = [NSDecimalNumber decimalNumberWithString:@"10"];
    PKPaymentSummaryItem *Item= [PKPaymentSummaryItem summaryItemWithLabel:@"张飞" amount:decimalNumber];
    
    NSDecimalNumber * decimalNumber1 = [NSDecimalNumber decimalNumberWithString:@"10"];
    PKPaymentSummaryItem *Item1= [PKPaymentSummaryItem summaryItemWithLabel:@"张飞1" amount:decimalNumber1];
    
    NSDecimalNumber * decimalNumber2 = [NSDecimalNumber decimalNumberWithString:@"20"];
    PKPaymentSummaryItem *Item2= [PKPaymentSummaryItem summaryItemWithLabel:@"公司" amount:decimalNumber2];
    //最后一条作为汇总
    
    pay.paymentSummaryItems =@[Item,Item1,Item2];
    //发票地址
    pay.requiredBillingAddressFields = PKAddressFieldAll;
    //快递地址
     pay.requiredShippingAddressFields = PKAddressFieldAll;
    //配置快递详情
    NSDecimalNumber * decimalNumberkuaidi = [NSDecimalNumber decimalNumberWithString:@"10"];
    PKShippingMethod *shipping = [PKShippingMethod summaryItemWithLabel:@"顺丰" amount:decimalNumberkuaidi];
    shipping.identifier = @"shunfeng";

    shipping.detail = @"24小时快递";
    NSDecimalNumber * decimalNumberkuaidi2 = [NSDecimalNumber decimalNumberWithString:@"10"];
    PKShippingMethod *shipping1 = [PKShippingMethod summaryItemWithLabel:@"韵达" amount:decimalNumberkuaidi2];
    shipping1.identifier = @"yunda";
    
    shipping1.detail = @"8小时快递";
    pay.shippingMethods = @[shipping,shipping1];
    //验证支付授权
    PKPaymentAuthorizationViewController *payVC = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:pay];
      payVC.delegate = self;
    [self presentViewController:payVC animated:YES completion:^{
        
    }];
    
    
  
    
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                      didAuthorizePayment:(PKPayment *)payment
                               completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    //拿到 支付信息发送给服务器,服务器返回状态告诉客户端是否支付成功;
    completion(PKPaymentAuthorizationStatusSuccess);
    
}
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    
    NSLog(@"授权结束");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

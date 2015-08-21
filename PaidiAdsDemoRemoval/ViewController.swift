//
//  ViewController.swift
//  InAppDemo
//
//  Created by Kristian Secor on 7/13/14.
//  Copyright (c) 2014 Kristian Secor. All rights reserved.
//

import StoreKit
import UIKit
import iAd


class ViewController: UIViewController,SKPaymentTransactionObserver, SKProductsRequestDelegate, ADBannerViewDelegate {
    
    @IBOutlet var bottomAdBanner: ADBannerView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var removeMsg: UILabel!
    
    var product: SKProduct!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var bottomAdBanner: ADBannerView;
        self.bottomAdBanner.hidden = false
        self.bottomAdBanner.delegate = self;
        buyButton.hidden = true
        
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("Ads") == nil)  {
            println("pay me or be annoyed forever!")
            
            SKPaymentQueue.defaultQueue().addTransactionObserver(self);
            self.getProductInfo();
        }
        
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("Ads") != nil)  {
            println("ads have been paid for")
            if var status: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("Ads"){
                if status as! NSString == "purchased" {
                    self.bottomAdBanner.removeFromSuperview()
                    self.buyButton.hidden = true;
                    self.buyButton.userInteractionEnabled = false
                }
                else {
                    SKPaymentQueue.defaultQueue().addTransactionObserver(self);
                    self.getProductInfo()
                }
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!){
        let products = response.products;
        if (products.count != 0)
        {
            product = products[0] as! SKProduct;
        }
        buyButton.hidden = false;
    }
    
    
    
    func getProductInfo(){
        if (SKPaymentQueue.canMakePayments()){
            let productID:NSSet = NSSet(object: "PaidiAdsDemoRemovalJoshOConnor");
            let request:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<NSObject>);
            request.delegate = self;
            request.start()
        }
        
    }
    
    
    func storePurchase(){
        NSUserDefaults.standardUserDefaults().setObject("purchased", forKey:"Ads")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.bottomAdBanner.removeFromSuperview()
        self.buyButton.hidden = true;
        self.buyButton.userInteractionEnabled = false
        removeMsg.text = "Your ads have been removed"
        
    }
    
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!){
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    self.storePurchase()
                    removeMsg.text = "Your ads have been removed"
                    break;
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    println("purchase failed")
                    break;
                case .Restored:
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                    println("purchase restored")
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    
    
    
    @IBAction func buyProduct(sender : AnyObject) {
        let payment:SKPayment = SKPayment(product: product);
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    
    
    
    func bannerView(banner: ADBannerView!,didFailToReceiveAdWithError error: NSError!){
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!){
        self.bottomAdBanner.hidden = false
    }
    
    
    func bannerViewWillLoadAd(banner: ADBannerView!){
        
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    
}


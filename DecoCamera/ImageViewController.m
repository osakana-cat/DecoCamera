
#import "ImageViewController.h"

@interface ImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) NSInteger countNumber;

@property (assign, nonatomic) BOOL isGray;
@property (assign, nonatomic) BOOL isBrightness;
@property (assign, nonatomic) BOOL isMinus;
@property (assign, nonatomic) BOOL isPlus;


- (IBAction)saveButtonAction:(id)sender;
- (IBAction)grayButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scale = 1;
    
    self.imageView.image = self.editImage;
    
    self.isGray = NO;
    self.isBrightness = NO;
    self.isMinus = NO;
    self.isPlus = NO;




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//画像保存用のメソッド
- (IBAction)saveButtonAction:(id)sender {
    
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);

    //画像をカメラロールに保存
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
}


//画像保存完了時のセレクタ
//画像保存完了時にセレクターが呼び出され、アラートを表示
- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存終了" message:@"画像を保存しました" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // ボタンを押した際に処理が必要ならここに書く

    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}




//ボタンアクション系


//+ or -のscaleの計算をして共通メソッドを呼び出す
-(IBAction)minusButtonAction:(id)sender{
    

        
        self.countNumber --;
    
        self.scale = [self culculateScale:self.countNumber];

        
        //Storyboard上のUIImageViewに画像を描画
        //editImageをresizeImageメソッドへ渡す(引数)
        //resultImageがself.imageView.imageに代入される  [self filterImage:self.editImage]イコールresultImage
        self.imageView.image = [self filterImage:self.editImage];



    

}

-(IBAction)plusButtonAction:(id)sender{
    
    


    self.countNumber ++;
    
    //戻り値の練習用
    self.scale = [self culculateScale:self.countNumber];
    //→self.scale = self.scale * 1.25
    
    self.imageView.image = [self filterImage:self.editImage];
    //editImageをresizeImageメソッドへ渡す(引数) 　毎回editimageを渡すため　明度・白黒の呼び出すメソッドが必要
    //resultImageがself.imageView.imageに代入される
        
    
    
        
}


//countNumberが引数　引数を使えば、呼び出す場所からメソッドに値を渡す
-(CGFloat)culculateScale:(NSInteger)countNumber{
    
    CGFloat result =1.0f;
    
    if (countNumber == 0) {
        //数値がちょうど０
        result = 1;
    }else if(countNumber > 0){
        //数値が＋
            for (NSInteger a = 0; a<= countNumber; a++) {
                result = result* 1.25;
            }
    }else if(countNumber<0){
        //数値がー
            for (NSInteger a = 0 ; a>= countNumber; a--) {
                result = result* 0.75;
            }
        }
    return result;
}




//グレイボタンを押した時
- (IBAction)grayButtonAction:(id)sender {
    
    self.isGray = !self.isGray;
    

    //このIF文で変更するのはGrayボタンの表示をリセットかGrayかを変更
     if (self.isGray) {

         
         [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
         
         
         
     } else {
         
         
         self.grayButton.titleLabel.text = @"Gray";
         [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
         
         
     }
    
    //Storyboard上のUIImageViewに画像を描画
    //editImageをresizeImageメソッドへ渡す(引数)
    //resultImageがself.imageView.imageに代入される  [self filterImage:self.editImage]イコールresultImage
    //self.imageView.imageには他の要素もあるため毎回呼び出す。
    self.imageView.image = [self filterImage:self.editImage];
    
    
}


- (IBAction)SliderChanged:(id)sender {


    
    //sliderの値はコードからハンドリングする必要がないため共通メソッドを呼び出すのみ
     self.imageView.image = [self filterImage:self.editImage];
        


}






//各フィルターの処理　　UIImage　sourceにself.editImageが代入される
- (UIImage*)filterImage:(UIImage*)source {
    
    //サイズ↓
    
    //縦と横のサイズ　self.scale→２倍にするか、２分の1にするか
    CGSize resizedSize = CGSizeMake(source.size.width * self.scale, source.size.height * self.scale);
    
    UIGraphicsBeginImageContext(resizedSize);
    
    [source drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    
    
    
    //オフスクリーンバッファをUIImageに変換
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    //オフスクリーンバッファを破棄
    //UIGraphicsEndImageContext();
    
    
    
    
    //白黒加工　これがサイズについてくる↓
    
    
    if (self.isGray) {
    CGRect imageRect = (CGRect){0.0, 0.0, resultImage.size.width, resultImage.size.height};
    
    // CoreGraphicsのモノクロ色空間を準備します
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // ビットマップコンテキストを作りサイズと色空間を設定します
    CGContextRef context = CGBitmapContextCreate(nil, resultImage.size.width, resultImage.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // ビットマップコンテキストに画像を描画します
    CGContextDrawImage(context, imageRect, [resultImage CGImage]);
    
    // ビットマップコンテキストに描画された画像を取得
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // 取得した画像からUIImageを作る→変換 拡大率明度を変更した画像とは別のUIImageが作成されているので、resutImageに変更後の画像を渡す
     //UIImage *grayScaleImage = [UIImage imageWithCGImage:imageRef];
    
    resultImage =  [UIImage imageWithCGImage:imageRef];
    
        
       
    
    CGColorSpaceRelease(colorSpace);
    CFRelease(imageRef);
    CGContextRelease(context);
    
    
        
    } else {
        
        
    }

        
    
    //明度↓
    
    //if (self.isBrightness) {
    
    
        
        // UIImageをCIImageに変換
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:resultImage];
        
        // フィルタの作成 @propatyで定義したものはself.をつける　self=imageViewContoroller
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls"
                                        keysAndValues:kCIInputImageKey, ciImage,
                              @"inputBrightness", [NSNumber numberWithFloat:self.slider.value],nil];
        // 結果画像の取り出し
        CIImage* filterdImage = [ciFilter outputImage];
        
        
        // CIImageからUIImageに変換
        NSDictionary *contextOptions = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],kCIContextUseSoftwareRenderer,nil];
        CIContext *ciContext = [CIContext contextWithOptions:contextOptions];
        CGImageRef imgRef = [ciContext createCGImage:filterdImage fromRect:[filterdImage extent]];
    
    
        resultImage = [UIImage imageWithCGImage:imgRef scale:1 orientation:UIImageOrientationUp];
    
    

     CGImageRelease(imgRef);
    //}

        
    
    
    //加工した画像を返す　返り値
    return resultImage;
}





- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

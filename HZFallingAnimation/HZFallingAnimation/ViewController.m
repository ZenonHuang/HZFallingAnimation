//
//  ViewController.m
//  HZFallingAnimation
//
//  Created by mewe on 2018/2/5.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,assign) BOOL isLaunching;
//粒子发射器
@property (nonatomic,strong) CAEmitterLayer *emitter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapLaunchButton:(UIButton *)sender {
    if (!self.isLaunching) {
        [self falling];
        self.isLaunching = YES;
        sender.backgroundColor = [UIColor redColor];
        [sender setTitle:@"停止发射" forState:UIControlStateNormal];

        return;
    }
    
    //停止生成粒子
    self.emitter.birthRate = 0;
    self.isLaunching = NO;
    sender.backgroundColor = [UIColor blueColor];
    [sender setTitle:@"发射" forState:UIControlStateNormal];
    
}

- (void)falling{
    
    //粒子发射器
    CAEmitterLayer *fallingEmitter = [CAEmitterLayer layer];
    //粒子发射的位置
    fallingEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width/2, 0);//CGPointMake(100, 80);
    //发射源的大小
    fallingEmitter.emitterSize = CGSizeMake(self.view.bounds.size.width, 0.0);
    //发射模式
    fallingEmitter.emitterMode = kCAEmitterLayerOutline;
    //发射源的形状
    fallingEmitter.emitterShape = kCAEmitterLayerLine;

    //设置阴影
    fallingEmitter.shadowOpacity = 1.0;
    fallingEmitter.shadowRadius = 0.0;
    fallingEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
    fallingEmitter.shadowColor = [[UIColor whiteColor] CGColor];
    
    //粒子
    CAEmitterCell *emitter1Cell=[self containerCell];
    CAEmitterCell *emitter2Cell=[self containerCell];
    //将粒子添加到粒子发射器上
    fallingEmitter.emitterCells = @[emitter1Cell,emitter2Cell];
    [self.view.layer insertSublayer:fallingEmitter atIndex:0];
    
    CAEmitterCell *rightCell=[self fallingCell];
    rightCell.xAcceleration  = 5;
    CAEmitterCell *leftCell =[self fallingCell];
    leftCell.xAcceleration   = -15;
    leftCell.yAcceleration   = [UIScreen mainScreen].bounds.size.height/10+10;
    leftCell.birthRate       = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        fallingEmitter.emitterCells = @[rightCell,leftCell];
    });

    
    self.emitter = fallingEmitter;
}

// 使用存活周期为 0 的 containerCell，避免lifetime*birthRate 个粒子直接铺满全屏
- (CAEmitterCell *)containerCell{
    CAEmitterCell* containerCell = [CAEmitterCell emitterCell];
    containerCell.name = @"containerLayer";
    containerCell.birthRate           = 1.0;

    return containerCell;
}

- (CAEmitterCell *)fallingCell{
    //创建雪花粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //粒子的名称
    snowflake.name = @"snow";
    //粒子参数的速度乘数因子。越大出现的越快,每秒产生的个数
    snowflake.birthRate = 3;
    
    float lifeTime = 10.0 ;
    //存活时间
    snowflake.lifetime = lifeTime;
    //粒子速度
//    snowflake.velocity = -50;                // falling down slowly
    //粒子速度范围
//    snowflake.velocityRange = 20;
    //粒子y方向的加速度分量
    snowflake.yAcceleration = [UIScreen mainScreen].bounds.size.height/lifeTime;
    snowflake.xAcceleration = 15;
    
    snowflake.scale   = 1;
    snowflake.scaleRange = 0.3;
    
    //周围发射角度
    //    snowflake.emissionRange = 0.5 * M_PI;        // some variation in angle
    //子旋转角度范围
    //    snowflake.spinRange = 0.25 * M_PI;        // slow spin
    
    //粒子图片
    snowflake.contents = (id)[[UIImage imageNamed:@"icon_app_diamond24"] CGImage];
    //粒子颜色
    //    snowflake.color = [[UIColor redColor] CGColor];
    return  snowflake;
}
@end

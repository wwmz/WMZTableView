//
//  ViewController.m
//  WMZTableView
//
//  Created by wmz on 2018/10/22.
//  Copyright © 2018年 wmz. All rights reserved.
//

#import "ViewController.h"
#import "WMZTableView.h"
@interface ViewController ()<WMZTableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    //最简单的调用
//    GroupTableView()
//    .wAutoCell(YES)
//    .wMasonryConfig(self.view, ^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }, self.modelArr)
//    .wStart();
    
    
    if (_type==0) {
        WMZWeakSelf
        GroupTableView()
        .wDealCell(^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView,id model) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            }
            cell.textLabel.text = model;
            return cell;
        }).wMasonryConfig(self.view, ^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }, self.dataArr)
        .wDidSelect(^(NSIndexPath *indexPath, UITableView *tableView,id model) {
            ViewController *VC = [ViewController new];
            VC.type = 1;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        })
        .wStart();



    }else{

        GroupTableView()
        .wAutoCell(YES)
        .wMasonryConfig(self.view, ^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }, self.modelArr)
//        .wCellHeight(^NSInteger(NSIndexPath *indexPath, UITableView *tableView) {
//            return indexPath.row == 0 ? 200:UITableViewAutomaticDimension;
//        })
//        .wCellFootHeight(^NSInteger(NSInteger section, UITableView *tableView) {
//            return 50;
//        })
//        .wCellFootView(^UIView *(NSInteger section, UITableView *tableView) {
//            UIView *view = [UIView new];
//            view.backgroundColor = [UIColor yellowColor];
//            return view;
//        })
//        .wCellHeadHeight(^NSInteger(NSInteger section, UITableView *tableView) {
//            return 50;
//        })
//        .wCellHeadView(^UIView *(NSInteger section, UITableView *tableView) {
//            UIView *view = [UIView new];
//            view.backgroundColor = [UIColor redColor];
//            return view;
//        })
//        .wSection(YES)
         .wStart();
        
//        ta.WMZdelegate = self;

    }
    
    
    
  
    
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithArray:@[@"cell1",@"cell2",@"cell3",@"cell4",@"cell5",@"cell6",@"cell7",@"cell8",@"cell9",@"cell10"]];
    }
    return _dataArr;
}

- (NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray new];
        
        int x = arc4random() % 30+10;
        int x1 = arc4random() % 3+1;
        int x2 = arc4random() % 6+4;
       for (int i = 0; i<x; i++) {
           int x3 = arc4random() % 10;
            wBaseModel *model = [wBaseModel new];
            if (i%x1==0) {
                model.cellName = @"NornalCell";
                model.labelName = @"NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本NornalCell的文本";
            }else if(i%x2==0){
                model.cellName = @"NornalCellOne";
                model.labelName = @"NornalCellOne的文本\nNornalCellOne的文本";
                model.imageName = [NSString stringWithFormat:@"%d.jpg",x3];
            }else{
                model.cellName = @"NornalCellSecond";
                model.imageName = [NSString stringWithFormat:@"%d.jpg",x3];
            }
//           Sections
//            [_modelArr addObject:@[model]];
           
//           Rows
            [_modelArr addObject:model];
        }
    }
    
    return _modelArr;
}




//如需调用此方法则tableView的头视图需要设为nil 才能生效
- (NSString *)WMZTableViewTitleForHeaderInSection:(NSInteger)section{
    return @"头标题";
}

//如需调用此方法则tableView的头视图需要设为nil 才能生效
- (NSString *)WMZTableViewTitleForFooterInSection:(NSInteger)section{
    return @"尾标题";
}

- (void)WMZTableViewCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
}

- (UITableViewCellEditingStyle)WMZTableViewEditingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)WMZTableViewTitleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"这是删除吗";
}

-(void)WMZTableViewWillDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end

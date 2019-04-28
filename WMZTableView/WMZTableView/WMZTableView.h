//
//  WMZTableView.h
//  WMZTableView
//
//  Created by wmz on 2018/10/22.
//  Copyright © 2018年 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"


#define  WMZWeakSelf __weak typeof(self) weakSelf = self;

#define  WMZStrongSelf __strong typeof(self) strongSelf = self;

@protocol WMZTableViewDelegate <NSObject>


@optional //非必实现的方法

/*
 * 头视图标题 如需调用此方法则tableView的头视图需要设为nil 才能生效
 */
- (NSString*)WMZTableViewTitleForFooterInSection:(NSInteger)section;

/*
 * 尾视图标题 如需调用此方法则tableView的头视图需要设为nil 才能生效
 */
- (NSString*)WMZTableViewTitleForHeaderInSection:(NSInteger)section;

/*
 * 设置删除/添加的样式
 */
-(UITableViewCellEditingStyle)WMZTableViewEditingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * 设置删除/添加的样式的显示内容
 */
-(NSString *)WMZTableViewTitleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * 删除/添加的样式的点击方法
 */
- (void)WMZTableViewCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath;

/*
 * cell将显示的方法
 */
- (void)WMZTableViewWillDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * cell开始编辑的方法
 */
- (void)WMZTableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * cell结束编辑的方法
 */
- (void)WMZTableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * 滑动
 */
- (void)WMZScrollViewDidScroll:(UIScrollView *)scrollView;

/*
 *滑动多图标
 */
- (NSArray<UITableViewRowAction *> *)WMZTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end






/*
 * cell的block
 */
typedef UITableViewCell* (^WMZCellCallBlock)(NSIndexPath *indexPath,UITableView* tableView,id model);

/*
 * cell点击的block
 */
typedef void(^WMZSelectCallBlock)(NSIndexPath *indexPath,UITableView* tableView,id model);

/*
 * cell高度的block
 */
typedef NSInteger (^WMZCellHeight)(NSIndexPath *indexPath,UITableView* tableView);


/*
 * cell数量的block
 */
typedef NSInteger (^WMZCellCount)(NSInteger section,UITableView* tableView);

/*
 * cell头视图高度的block
 */
typedef NSInteger (^WMZCellHeadHeight)(NSInteger section,UITableView* tableView);

/*
 * cell尾视图高度的block
 */
typedef NSInteger (^WMZCellFootHeight)(NSInteger section,UITableView* tableView);

/*
 * cell头视图的block
 */
typedef UIView * (^WMZCellHeadView)(NSInteger section,UITableView* tableView);

/*
 * cell尾视图的block
 */
typedef UIView * (^WMZCellFootView)(NSInteger section,UITableView* tableView);


/*
 * 布局
 */
typedef void(^WMZConstraint) (MASConstraintMaker *make);


typedef enum : NSUInteger{
    /*
     *默认是一个section，row = dataArr的数量
     */
    CellTypeRows = 0,
    /*
     *默认是 的数量section数量是dataArr的数量   row对应子数组的数量
     *格式必须是 @[@[],@[],@[]]
     */
    CellTypeSections = 1,
}CellType;


@interface WMZTableView : UITableView
/* =========================================重要属性==============================================*/
/* =========================================重要属性==============================================*/
/* =========================================重要属性==============================================*/

/*
 * 初始化 Group样式
 */
WMZTableView * GroupTableView(void);

/*
 * 初始化 Plain样式
 */
WMZTableView * PlainTableView(void);


/*
 * 代理和dataSource开始 最后一步一定要调用这个属性 否则不生效
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wStart)(void);

/*
 * frame布局
 * 数据源
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wFrameConfig)(UIView *wParentView,CGRect wFrame,NSMutableArray *myDataArr);

/*
 * masonry布局
 * 数据源
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wMasonryConfig)(UIView *wParentView,WMZConstraint wMasonry,NSMutableArray *myDataArr);

/*
 * cell方法
 * 自定义外层自己传进来
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wDealCell)(WMZCellCallBlock block);


/*
 * cell点击
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wDidSelect)(WMZSelectCallBlock block);



/*
 *  更新数据 把改变完的数组传进来即可 自动局部刷新
 */
@property(nonatomic,strong,readonly) WMZTableView *(^wUpdateData)(NSMutableArray *changeData);


/*
 *  WMZ代理 其他的tableview的代理方法
 */
@property(nonatomic,weak,readonly) WMZTableView *(^wOtherDelegate)(id <WMZTableViewDelegate> delegate);

/* =========================================重要属性==============================================*/
/* =========================================重要属性==============================================*/
/* =========================================重要属性==============================================*/




/* =========================================拓展属性==============================================*/
/* =========================================拓展属性==============================================*/
/* =========================================拓展属性==============================================*/


/*
 *  kvc写法 适合继承或直接使用wBaseModel 需要传cell对应class的名字 对组件化熟悉的可以调用 模型控制UI
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wAutoCell)(BOOL autoCell);


/*
 *  开启默认tableview配置
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wConfig)(BOOL config);


/*
 * wSection 是section
 
 *默认NO
 *默认是一个section，row = dataArr的数量

 *YES的时候 section数量是dataArr的数量   row对应子数组的数量
 *格式必须是 @[@[],@[],@[]]
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wSection)(BOOL isSection);


/*
 * 设置cell高度
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wCellHeight)(WMZCellHeight block);

/*
 * 设置cell头视图高度
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wCellHeadHeight)(WMZCellHeadHeight block);

/*
 * 设置cell尾视图高度
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wCellFootHeight)(WMZCellFootHeight block);

/*
 * 设置cell头视图样式
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wCellHeadView)(WMZCellHeadView block);

/*
 * 设置cell尾视图样式
 */
@property(nonatomic,copy,readonly) WMZTableView *(^wCellFootView)(WMZCellFootView block);


/*
 * cell显示有动画
 */
@property(nonatomic,assign,readonly) WMZTableView *(^wCellAnaiml)(BOOL cellAnaiml);



/* =========================================拓展属性==============================================*/
/* =========================================拓展属性==============================================*/
/* =========================================拓展属性==============================================*/


@end




/* =========================================额外类==============================================*/
/* =========================================额外类==============================================*/
/* =========================================额外类==============================================*/


//自定义baseModel类
@interface wBaseModel : NSObject<NSCopying>

@property(nonatomic,copy)NSString *cellName;

@property(nonatomic,copy)NSString *imageName;

@property(nonatomic,copy)NSString *labelName;

@end

//自定义baseCell 可以自己设置
@interface wBaseCell : UITableViewCell

@property(nonatomic,strong)wBaseModel *model;

@end

//自定义 cell 可以自己设置
@interface NornalCell : wBaseCell

@property(nonatomic,strong)UILabel *myLabel;

@end

@interface NornalCellOne : wBaseCell

@property(nonatomic,strong)UILabel *myLabel;

@property(nonatomic,strong)UIImageView *icon;

@end

@interface NornalCellSecond : wBaseCell

@property(nonatomic,strong)UIImageView *icon;

@end

/* =========================================额外类==============================================*/
/* =========================================额外类==============================================*/
/* =========================================额外类==============================================*/

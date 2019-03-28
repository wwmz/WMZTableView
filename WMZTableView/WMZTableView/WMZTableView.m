

//
//  WMZTableView.m
//  WMZTableView
//
//  Created by wmz on 2018/10/22.
//  Copyright © 2018年 wmz. All rights reserved.
//

#define TICK   NSDate *startTime = [NSDate date];

#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);

#import "WMZTableView.h"
@interface WMZTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL scrolAnimal;                      //滚动有动画

@property (nonatomic, assign) BOOL cellKVO ;                         //cell 是否是kvo写法

@property (nonatomic, assign) BOOL config ;                          //tableview开启默认配置

@property (nonatomic, strong) UIView *parentView;                    //parentView

@property (nonatomic, strong) NSMutableArray *dataArr;               //dataArr

@property (nonatomic, assign) BOOL isSection;                        //section

@property (nonatomic,   copy) WMZCellCallBlock cellBlock;            //cell block

@property (nonatomic,   copy) WMZSelectCallBlock selectBlock;        //cell 点击block

@property (nonatomic,   copy) WMZCellHeight cellHeightBlock;         //cell高度

@property (nonatomic,   copy) WMZCellCount cellCountBlock;           //cell数量

@property (nonatomic, copy)   WMZCellHeadHeight headHeightBlock;     //cell头部高度

@property (nonatomic, copy)   WMZCellFootHeight footHeightBlock;     //cell底部高度

@property (nonatomic, copy)   WMZCellHeadView headViewBlock;         //cell头部视图

@property (nonatomic, copy)   WMZCellFootView footViewBlock;         //cell底部视图


@end
@implementation WMZTableView

/*
 * 初始化
 */
WMZTableView * GroupTableView(void){
    
    return  [[WMZTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}

/*
 * 初始化
 */
WMZTableView * PlainTableView(void){
     return  [[WMZTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
}

/*
 * 代理和dataSource开始 最后一步一定要调用这个属性 否则不生效
 */
- (WMZTableView *(^)(void))wStart{
    return ^WMZTableView*(){
        if (self.config) {
            if (@available(iOS 11.0, *)) {
                self.estimatedSectionFooterHeight = 0.01;
                self.estimatedSectionHeaderHeight = 0.01;
            }
            self.rowHeight = UITableViewAutomaticDimension;
            self.estimatedRowHeight = 100.0f;
            self.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        if ([self reginerCell]) {
            self.delegate = self;
            self.dataSource = self;
        }
        return self;
    };
}


- (WMZTableView *(^)( UIView *, CGRect, NSMutableArray *))wFrameConfig{
    return ^WMZTableView*(UIView *wParent,CGRect wFrame,NSMutableArray* wDataArr){

        if (wDataArr) {
            //强引用
            self.dataArr = wDataArr;
        }
        self.frame = wFrame;
        if (wParent) {
            [wParent addSubview:self];
        }
        
        return self;
    };
}

- (WMZTableView *(^)(UIView *, WMZConstraint, NSMutableArray *))wMasonryConfig{
    return ^WMZTableView*(UIView *wParent,WMZConstraint wMasonry,NSMutableArray* wDataArr){
        if (wDataArr) {
            //强引用
            self.dataArr = wDataArr;
        }
        if (wParent) {
            [wParent addSubview:self];
            if (wMasonry) {
                [self mas_makeConstraints:wMasonry];
            }
        }
        return self;
    };
}

/*
 *注册cell
 */
- (BOOL)reginerCell{
    TICK
    if (!self.cellKVO) return YES;
    
    NSMutableArray *cellNameArr = [NSMutableArray new];
    
    if (CellTypeSections == self.isSection ) {
        for (NSArray *arr in self.dataArr) {
            if(![arr isKindOfClass:[NSArray class]]){
                NSLog(@"请输入正确的数据源 格式为@[@[],@[],@[]]");
                return NO;
            }
            for (wBaseModel *model in arr) {
                if ([cellNameArr indexOfObject:model.cellName]!=NSNotFound) continue;
                if (model.cellName) [cellNameArr addObject:model.cellName];
            }
        }
    }else{
        for (wBaseModel *model in self.dataArr) {
            if(![model isKindOfClass:[wBaseModel class]]){
                NSLog(@"请输入正确的数据源 格式为@[wBaseModel,wBaseModel,wBaseModel]");
                return NO;
            }
            if ([cellNameArr indexOfObject:model.cellName]!=NSNotFound) continue;
            if (model.cellName) [cellNameArr addObject:model.cellName];
        }
    }
    
    for (NSString *cellName in cellNameArr) {
        if (cellName) {
            Class cellClass = NSClassFromString(cellName);
            [self registerClass:[cellClass class] forCellReuseIdentifier:cellName];
        }
    }
    TOCK
    return YES;
}

- (WMZTableView *(^)(WMZCellCallBlock))wDealCell{
    return ^WMZTableView*(WMZCellCallBlock wDealCell){
        if (wDealCell) {
            self.cellBlock = wDealCell;
        }
        return self;
    };
}

- (WMZTableView *(^)(NSArray *))wDealKVOCell{
    return ^WMZTableView*(NSArray *cellNameArr){
        if ([cellNameArr isKindOfClass:[NSArray class]]&&cellNameArr.count>0) {
            self.cellKVO  = YES;
            for (NSString *cellName in cellNameArr) {
                if (cellName) {
                    Class cellClass = NSClassFromString(cellName);
                    [self registerClass:[cellClass class] forCellReuseIdentifier:cellName];
                }
            }
        }
        return self;
    };
}

- (WMZTableView *(^)(WMZSelectCallBlock))wDidSelect{
    return ^WMZTableView*(WMZSelectCallBlock wDidSelect){
        if (wDidSelect) {
            self.selectBlock = wDidSelect;
        }
        return self;
    };
}


- (WMZTableView *(^)(WMZCellHeight))wCellHeight{
    return ^WMZTableView*(WMZCellHeight block){
        if (block) {
            self.cellHeightBlock = block;
        }
        return self;
    };
}



/*
 * 设置cell头视图高度
 */
- (WMZTableView *(^)(WMZCellHeadHeight))wCellHeadHeight{
    return ^WMZTableView*(WMZCellHeadHeight block){
        if (block) {
            self.headHeightBlock = block;
        }
        return self;
    };
}

/*
 * 设置cell尾视图高度
 */
- (WMZTableView *(^)(WMZCellFootHeight))wCellFootHeight{
    return ^WMZTableView*(WMZCellFootHeight block){
        if (block) {
            self.footHeightBlock = block;
        }
        return self;
    };
}

/*
 * 设置cell头视图样式
 */
- (WMZTableView *(^)(WMZCellHeadView))wCellHeadView{
    return ^WMZTableView*(WMZCellHeadView block){
        if (block) {
            self.headViewBlock = block;
        }
        return self;
    };
}


/*
 * 设置cell尾视图样式
 */
- (WMZTableView *(^)(WMZCellFootView))wCellFootView{
    return ^WMZTableView*(WMZCellFootView block){
        if (block) {
            self.footViewBlock = block;
        }
        return self;
    };
}



- (WMZTableView *(^)(BOOL))wSection{
    return ^WMZTableView*(BOOL wSection){
        self.isSection = wSection;
        return self;
    };
}


- (WMZTableView *(^)(BOOL))wCellAnaiml{
    return ^WMZTableView*(BOOL wCellAnaiml){
        self.scrolAnimal = wCellAnaiml;
        return self;
    };
}


- (WMZTableView *(^)(BOOL))wAutoCell{
    return ^WMZTableView*(BOOL wAutoCell){
        self.cellKVO = wAutoCell;
        return self;
    };
}

- (WMZTableView *(^)(BOOL))wConfig{
    return ^WMZTableView*(BOOL wConfig){
        self.config = wConfig;
        return self;
    };
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellHeightBlock) {
        return self.cellHeightBlock(indexPath,tableView);
    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.isSection == CellTypeSections ? self.dataArr.count:1 ;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isSection == CellTypeSections ? [self.dataArr[section] count]:self.dataArr.count ;

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.footViewBlock) {
        return self.footViewBlock(section,tableView);
    }
    return [UIView new];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.headViewBlock) {
        return self.headViewBlock(section,tableView);
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (self.footHeightBlock) {
        return self.footHeightBlock(section,tableView);
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.headHeightBlock) {
        return self.headHeightBlock(section,tableView);
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    wBaseModel *model = (self.isSection == CellTypeSections?self.dataArr[indexPath.section][indexPath.row]:self.dataArr[indexPath.row]);
    if (self.cellKVO) {
        if (model) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellName];
            [cell setValue:model forKey:@"model"];
            return cell;
        }
    }else{
        if (self.cellBlock) {
            return self.cellBlock(indexPath,tableView,model);
        }
    }
    return [UITableViewCell new];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectBlock) {
         wBaseModel *model = (self.isSection == CellTypeSections?self.dataArr[indexPath.section][indexPath.row]:self.dataArr[indexPath.row]);
         self.selectBlock(indexPath,tableView,model);
    }
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZScrollViewDidScroll:)]) {
        [self.WMZdelegate WMZScrollViewDidScroll:scrollView];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewTitleForFooterInSection:)]) {
        return [self.WMZdelegate WMZTableViewTitleForFooterInSection:section];
    }
    return nil;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewTitleForHeaderInSection:)]) {
        return [self.WMZdelegate WMZTableViewTitleForHeaderInSection:section];
    }
    return nil;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewEditingStyleForRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableViewEditingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewTitleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableViewTitleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewCommitEditingStyle:forRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableViewCommitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.scrolAnimal) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        //还原
        [UIView animateWithDuration:1 animations:^{
            cell.layer.transform = CATransform3DIdentity;
        }];
    }
    
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableViewWillDisplayCell:forRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableViewWillDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}




- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableView:willBeginEditingRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableView:didEndEditingRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.WMZdelegate && [self.WMZdelegate respondsToSelector:@selector(WMZTableView:editActionsForRowAtIndexPath:)]) {
        return [self.WMZdelegate WMZTableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}


@end

@implementation wBaseModel

@end


@implementation wBaseCell

@end


@implementation NornalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.myLabel];

        [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setModel:(wBaseModel *)model{
    self.myLabel.text = model.labelName;
}

- (UILabel *)myLabel{
    if (!_myLabel) {
        _myLabel = [UILabel new];
        _myLabel.numberOfLines = 0;
        
    }
    return _myLabel;
}

@end

@implementation NornalCellOne

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.myLabel];
        [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-30);
            make.top.equalTo(self.myLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setModel:(wBaseModel *)model{
     self.myLabel.text = model.labelName;
     self.icon.image = [UIImage imageNamed:model.imageName];
}

- (UILabel *)myLabel{
    if (!_myLabel) {
        _myLabel = [UILabel new];
        _myLabel.numberOfLines = 0;
        
    }
    return _myLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"6.jpg"];
    }
    return _icon;
}


@end

@implementation NornalCellSecond

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(80);
            make.right.equalTo(self.contentView).offset(-80);
            make.top.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"6.jpg"];
    }
    return _icon;
}

- (void)setModel:(wBaseModel *)model{
     self.icon.image = [UIImage imageNamed:model.imageName];
}

@end

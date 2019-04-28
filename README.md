# WMZTableView
//简单的封装tableview通过链式调用
GroupTableView()
.wAutoCell(YES)
.wMasonryConfig(self.view, ^(MASConstraintMaker *make) {
  make.edges.mas_equalTo(0);
  }, self.modelArr)
  
 1 支持自定义自己写cell
 2 支持通过model控制cell不需要import cell类 ，直接插入指定的model即可 不需要写cell的实现方法
 3 支持局部刷新

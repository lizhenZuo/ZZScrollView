#!/usr/bin/env bash
# coderqh 2020/6/9

#定义输出色值
color_red='\033[31m'
color_yellow='\033[33m'
color_green='\033[32m'
color_end='\033[0m'

echo "===== 开始进入推送Pod到主仓库流程 ====="

#1、动态输入spec.version 同步修改podspec文件
podspec='ZZScrollView.podspec'

#2 tag的列举 &输入 &校验
var_git_all_tags="`git tag -l`"
echo "$color_green 所有tags：\n$var_git_all_tags $color_end"
read -p "输入新的tag版本:" tag
var_check_tag=$(echo "$var_git_all_tags" | grep "$tag")
if [[ "$var_check_tag" != "" ]]
then
    echo "$color_red 当前'$tag' tag已存在,请重新执行 $color_end"
    exit
else
    echo "$color_green 正在制作git标签：$tag... $color_end"
fi

#3、podspec删除version 新增新的version
version="spec.version='$tag'"
gsed -i '3 d' $podspec
gsed -i "2a $version" $podspec

#4、用户输入提交git commit -am 的注释
echo "提交代码中......"
read -p "输入提交信息:" remark
git add -A .
git commit -m "$remark"
git push origin
echo "提交完成......"

#5、打tag
echo "开始打tag......"
git tag "$tag"
git push origin "$tag"
echo "打tag完成"

#6、推送到ZZScrollView
echo "推送到ZZScrollView......"
pod repo push $podspec --use-libraries --allow-warnings --verbose

#7、成功输出
if [ $? -eq 0 ]
then
    echo "$color_green >>>>>>>>>>>> 恭喜你，Pod已经成功推送到主仓库 版本号：'$tag' <<<<<<<<<<< \n $(cat $podspec) $color_end"
else
    echo "执行失败"
fi



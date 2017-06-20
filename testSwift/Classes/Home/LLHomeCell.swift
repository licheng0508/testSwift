//
//  LLHomeCell.swift
//  testSwift
//
//  Created by licheng on 2016/12/28.
//  Copyright © 2016年 licheng. All rights reserved.
//

import UIKit

class LLHomeCell: UITableViewCell {

    /// 配图视图
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    /// 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 底部视图
    @IBOutlet weak var footerView: UIView!
    ///数据模型
    var viewModel : StatusViewModel?
        {
        didSet{
            
            // 1.设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL as URL?, placeholderImage: UIImage(named: "avatar_default"))
            
            // 2.设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            // 3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 4.设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage
            {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            // 5.设置时间
            timeLabel.text = viewModel?.created_Time
            
            // 6.设置来源
            sourceLabel.text = viewModel?.source_Text
            
            // 7.设置正文
            contentLabel.text = viewModel?.status.text
            
            //8.设置配图
            pictureCollectionView.reloadData()
            
            //9.更新配图
            let (itemSize, colvSize) = calculateSize()
            if itemSize != CGSize.zero {
                flowLayout.itemSize = itemSize
            }
            pictureCollectionViewHeightCons.constant = colvSize.height
            pictureCollectionViewWidthCons.constant = colvSize.width
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //1.设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = getMainScreenWidth() - 2*10
        
        //2.注册pictureCell
        let cellNib = UINib(nibName: "LLHomePictureCell", bundle: nil)
        pictureCollectionView.register(cellNib, forCellWithReuseIdentifier: "LLHomePictureCell")
        
    }

    // MARK: - 外部控制方法
    func calculateRowHeight(viewModel: StatusViewModel) -> CGFloat
    {
        // 1.设置数据
        self.viewModel = viewModel
        
        // 2.跟新UI
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y
        return footerView.frame.maxY
    }
    
    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        let count = viewModel?.thumbnail_pic?.count ?? 0
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = viewModel!.thumbnail_pic!.first!.absoluteString
            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
            guard  let image = SDImageCache.shared().imageFromCache(forKey: key) else {
                return (CGSize.zero, CGSize.zero)
            }
            return (image.size, image.size)
        }
        
        let imageWidth: CGFloat = (getMainScreenWidth() - 30) / 3
        let imageHeight: CGFloat = imageWidth
        let imageMargin: CGFloat = 5
        // 四张配图
        if count == 4
        {
            let col = 2
            let row = col
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        
    }
}

extension LLHomeCell: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LLHomePictureCell", for: indexPath) as! LLHomePictureCell
        
        cell.url = viewModel?.thumbnail_pic?[indexPath.item]
        
        return cell
    }
}


class LLHomePictureCell: UICollectionViewCell {
    
    var url: NSURL?
        {
        
        didSet {
            
            customIconImageView.sd_setImage(with: url as URL?)
            
        }
    }
    
    @IBOutlet weak var customIconImageView: UIImageView!
}





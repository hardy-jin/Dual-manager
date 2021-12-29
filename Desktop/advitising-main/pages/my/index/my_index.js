
const pageHelper = require('../../../helper/page_helper.js');
let rewardedVideoAd = null;
let count = 0;
Page({

	/**
	 * 页面的初始数据
	 */
	data: {
		coin1: 0,
		user: null,
		username: "1"
	},
	openAd: async function(event){
		rewardedVideoAd.show().catch(() => {
			rewardedVideoAd.load()
			.then(() => rewardedVideoAd.show())
			.catch(async (err) => {
				console.log('激励视频 广告显示失败');
				// should be put in "onClose && isEnded"
				await wx.cloud.callFunction({
					name: 'quickstartFunctions',
					config: {
						env: this.data.envId
					},
					data: {
						type: 'incCoin'
					}
				});
				await this._getUserInfo();
			})
	});
	// await cloudHelper.callCloudData('updateCoin', {}, opt);


	},

	changeName: async function(){
		wx.showModal({
			title: '更改游戏ID',
			content: '',
			editable: true,
			
		}).then(async (res) => {
			if(res.confirm){
				console.log(res);
				let foo = await wx.cloud.callFunction({
					name: 'quickstartFunctions',
					config: {
						env: this.data.envId
					},
					data: {
						type: 'updateUserName',
						data:{
							username: res.content
						}
					}
				});
				console.log(foo);
				await this._getUserInfo();
			}
			else{
				console.log("取消");
			}
		});
		
	},

	_getUserInfo: async function(){
		wx.showLoading({
      title: '',
    });
		let res = await wx.cloud.callFunction({
			name: 'quickstartFunctions',
      config: {
        env: this.data.envId
      },
      data: {
        type: 'getUserInfo'
      }
		});
		if(res){
			this.setData({
				username: res.result.data.username,
				coin1: res.result.data.coin1
			})
		}
		wx.hideLoading();

	},
	/**
	 * 生命周期函数--监听页面加载
	 */
	onLoad: async function (options) { 
		if(wx.createRewardedVideoAd){
      rewardedVideoAd = wx.createRewardedVideoAd({ adUnitId: 'xxxx' })
      rewardedVideoAd.onLoad(() => {
        console.log('onLoad event emit')
      })
      rewardedVideoAd.onError((err) => {
        console.log('onError event emit', err)
      })
			rewardedVideoAd.onClose(res => {
				// 用户点击了【关闭广告】按钮
				if (res && res.isEnded) {
					console.log('播放成功')
				} else {
					console.log('播放失败')
				}
			});
		}
		
		await this._getUserInfo();
		
		// await this._login();
	},

	/**
	 * 生命周期函数--监听页面初次渲染完成
	 */
	onReady: function () {},

	/**
	 * 生命周期函数--监听页面显示
	 */
	onShow: async function () {

	},

	/**
	 * 生命周期函数--监听页面隐藏
	 */
	onHide: function () {

	},

	/**
	 * 生命周期函数--监听页面卸载
	 */
	onUnload: function () {

	},

	/**
	 * 页面相关事件处理函数--监听用户下拉动作
	 */
	onPullDownRefresh: async function () {
		//await this._login();
		wx.stopPullDownRefresh();
	},

	//登录

	/**
	 * 页面上拉触底事件的处理函数
	 */
	onReachBottom: function () {

	},


	url: function (e) {
		pageHelper.url(e);
	},


 

})
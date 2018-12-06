class GoodsDataController < ApplicationController
  def initialize
    super
    @pagenum = 0
  end

  def new
    f = File.new('./goods.txt', 'a:utf-8')
    data = request.params
    f.puts(data)
    f.close
    save(request.params)
  end

  def show
    user = User.find_by(name: cookies[:name])
    if user.nil?
      render json:{code:"false"}
    else
      if user.admin == "1"
        url_list = []
        num = params[:num]
        s = Spulist.limit(num).offset(@pagenum)
        @pagenum += num.to_i
        puts num, @pagenum, '=====更新的页数========'
        for i in s
          url = i.url
          url_list.push(url)
        end
        puts url_list, '==========更新url列表============='
        render json: {code:"true", url_list:url_list}
      else
        render json: {code:"false"}
      end
      end
  end

  def sku_data(text, sku_old=nil)
    skulist = text["script_text"]["valItemInfo"]["skuList"]
    for goods_sku in skulist
      sku = sku_old == nil ? Skulist.new() : sku_old
      sku.skuid = goods_sku[1]["skuId"]
      sku.size = goods_sku[1]["pvs"].split(';')[0]
      sku.style = goods_sku[1]["pvs"].split(';')[1]
      sku.spuid = text["script_text"]["itemDO"]["spuId"]
      sku.stock = text["script_text"]["valItemInfo"]["skuMap"][';'+ goods_sku[1]["pvs"]+ ';']["stock"]
      sku.price = text["script_text"]["valItemInfo"]["skuMap"][';'+ goods_sku[1]["pvs"]+ ';']["price"]
      rul = $r1.sadd("sku_key", sku.skuid)
      #当通过redis过滤或者是更新数据的时候,保存sku
      if rul == true || sku_old != nil
        sku.save
      end
    end
  end

  def spu_data(text)
    spu = Spulist.new()
    spu.spuid = text["script_text"]["itemDO"]["spuId"]
    puts spu.spuid, '========spuid========='
    spu.title = text["script_text"]["itemDO"]["title"]
    spu.price = text["script_text"]["detail"]["defaultItemPrice"]
    spu.discount_price = text["script_text"]["detail"]["defaultdiscountprice"]
    spu.url = text["price_data"]["goods_url"]
    spu.details = text["specification_dict"]
    rul = $r2.sadd("spu_kye", spu.spuid)
    if rul == true
      spu.save
    # elsif sig == true
    #   spu.save
    end
  end

  def size_data(text)
    name_list = text["script_text"]["valItemInfo"]["skuList"]
    for i in name_list
      size = Size.new()
      size.sizename = i[1]["names"].split(' ')[0]
      size.sizenum = i[1]["pvs"].split(";")[0]
      rul = $r3.sadd("size_key", size.sizenum)
      if rul == true
        size.save
      end
    end
  end

  def style_data(text)
    name_list = text["script_text"]["valItemInfo"]["skuList"]
    style_dict = text["script_text"]["propertyPics"]
    price_dict = text["price_data"]["price"]
    for i in name_list
      style = Style.new()
      style.stylename  = i[1]["names"].split(' ')[1]
      style.stylenum = i[1]["pvs"].split(";")[1]
      stylekey = ';' + style.stylenum+ ';'
      style.imgurl = "https://" + style_dict[stylekey][0]
      style.discount_price = price_dict[style.stylenum]["discount_price"]
      style.isonsale = price_dict[style.stylenum]["on_sale"]
      rul = $r4.sadd("style_key", style.stylenum)
      if rul == true
        style.save
      end
    end
  end

  def save(data)
    sku_data(data)
    spu_data(data)
    size_data(data)
    style_data(data)
  end

  def update
    text = request.params
    skulist = text["script_text"]["valItemInfo"]["skuList"]
    spuid = text["script_text"]["itemDO"]["spuId"]
    sku_obj_list = Skulist.where("spuid=?", spuid)
    sku_list = []
    sku_obj_list.each {|sku_object| sku_list.push sku_object.skuid}
    skuid_list_extra = []
    skulist.each do |index, value_dict|
      skuid_new = value_dict['skuId']
      if sku_list.include? skuid_new
        #调用更新函数,
        sku_data(text, Skulist.find_by_skuid(skuid_new))
        # 将页面获取的text中的sku在数据库中有记录的添加进一个新的列表
        skuid_list_extra.push skuid_new
      else
        # 调用添加函数
        save text
      end
      array_extra = sku_list - skuid_list_extra
      if array_extra.empty?
        array_extra.each {|sku| Skulist.find_by_skuid(sku).destroy}
      end
    end
    render json: {code:'true'}
  end

end




package com.bjpowernode;

import com.bjpowernode.mapper.ProductInfoMapper;
import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.ProductInfoExample;
import com.bjpowernode.pojo.vo.ProductInfoVo;
import com.bjpowernode.util.MD5Util;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext_dao.xml", "classpath:applicationContext_service.xml"})
public class MyTest {

    @Autowired
    ProductInfoMapper productInfoMapper;

    @Test
    public void testMD5() {
        String str = MD5Util.getMD5("000000");
        System.out.println(str);
    }

    @Test
    public void testSelectByCondition() {
        ProductInfoVo vo = new ProductInfoVo();
        vo.setpName("4");
        vo.setTypeId(1);
        vo.setlPrice(1000);
        vo.sethPrice(4000);
        List<ProductInfo> list = productInfoMapper.selectByCondition(vo);
        list.forEach(productInfo -> System.out.println(productInfo));
    }
}

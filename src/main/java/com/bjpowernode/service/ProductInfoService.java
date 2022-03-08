package com.bjpowernode.service;

import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.vo.ProductInfoVo;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ProductInfoService {

    PageInfo<ProductInfo> split(int pageNum, int pageSize);

    int save(ProductInfo info);

    ProductInfo getById(Integer pId);

    int update(ProductInfo info);

    int delete(Integer pId);

    int deleteBatch(String[] pId);

    List<ProductInfo> selectByCondition(ProductInfoVo vo);

    PageInfo<ProductInfo> splitByCondition(ProductInfoVo vo, Integer pageSize);

}

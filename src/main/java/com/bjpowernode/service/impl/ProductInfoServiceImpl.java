package com.bjpowernode.service.impl;

import com.bjpowernode.mapper.ProductInfoMapper;
import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.ProductInfoExample;
import com.bjpowernode.pojo.vo.ProductInfoVo;
import com.bjpowernode.service.ProductInfoService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductInfoServiceImpl implements ProductInfoService {

    @Autowired
    private ProductInfoMapper productInfoMapper;

    @Override
    public PageInfo<ProductInfo> split(int pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);

        ProductInfoExample example = new ProductInfoExample();
        example.setOrderByClause("p_id desc");
        List<ProductInfo> list = productInfoMapper.selectByExample(example);
        PageInfo<ProductInfo> info = new PageInfo<>(list);
        return info;
    }

    @Override
    public int save(ProductInfo info) {
        return productInfoMapper.insert(info);
    }

    @Override
    public ProductInfo getById(Integer pId) {
        return productInfoMapper.selectByPrimaryKey(pId);
    }

    @Override
    public int update(ProductInfo info) {
        return productInfoMapper.updateByPrimaryKey(info);
    }

    @Override
    public int delete(Integer pId) {
        return productInfoMapper.deleteByPrimaryKey(pId);
    }

    @Override
    public int deleteBatch(String[] pId) {
        return productInfoMapper.deleteBatch(pId);
    }

    @Override
    public List<ProductInfo> selectByCondition(ProductInfoVo vo) {
        return productInfoMapper.selectByCondition(vo);
    }

    @Override
    public PageInfo<ProductInfo> splitByCondition(ProductInfoVo vo, Integer pageSize) {
        PageHelper.startPage(vo.getPageNum(),pageSize);
        List<ProductInfo> list = productInfoMapper.selectByCondition(vo);
        return new PageInfo<>(list);
    }
}

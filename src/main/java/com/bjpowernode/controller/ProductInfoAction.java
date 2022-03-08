package com.bjpowernode.controller;

import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.vo.ProductInfoVo;
import com.bjpowernode.service.ProductInfoService;
import com.bjpowernode.util.FileNameUtil;
import com.github.pagehelper.PageInfo;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/prod")
public class ProductInfoAction {

    private static final int PAGE_SIZE = 5;

    private String saveFileName = "";

    @Autowired
    private ProductInfoService productInfoService;

    @RequestMapping("/split.action")
    public String split(HttpServletRequest request) {
        PageInfo<ProductInfo> info = null;
        Object vo = request.getSession().getAttribute("vo");
        if (vo != null) {
            info = productInfoService.splitByCondition((ProductInfoVo) vo, PAGE_SIZE);
            request.getSession().removeAttribute("vo");
        } else {
            info = productInfoService.split(1, PAGE_SIZE);
        }
        request.setAttribute("info", info);
        return "product";
    }

    @ResponseBody
    @RequestMapping("/ajaxsplit.action")
    public void ajaxSplit(ProductInfoVo vo, HttpSession session) {
        PageInfo<ProductInfo> info = productInfoService.splitByCondition(vo, PAGE_SIZE);
        session.setAttribute("info", info);
    }


    @ResponseBody
    @RequestMapping("/ajaxImg.action")
    public Object ajaxImg(MultipartFile pimage, HttpServletRequest request) {
        saveFileName = FileNameUtil.getUUIDFileName() + FileNameUtil.getFileType(pimage.getOriginalFilename());
        String path = request.getServletContext().getRealPath("/image_big");
        try {
            pimage.transferTo(new File(path + File.separator + saveFileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject object = new JSONObject();
        object.put("imgurl", saveFileName);
        return object.toString();
    }

    @RequestMapping("/save.action")
    public String save(ProductInfo info, HttpServletRequest request) {
        info.setpImage(saveFileName);
        info.setpDate(new Date());
        int num = productInfoService.save(info);
        if (num == 1) {
            request.setAttribute("msg", "添加成功");
        } else {
            request.setAttribute("msg", "添加失败");
        }
        saveFileName = "";
        return "forward:/prod/split.action";
    }

    @RequestMapping("/one.action")
    public String one(Integer pId, ProductInfoVo vo, Model model, HttpSession session) {
        ProductInfo prod = productInfoService.getById(pId);
        model.addAttribute("prod", prod);
        session.setAttribute("vo", vo);
        return "update";
    }

    @RequestMapping("/update.action")
    public String update(ProductInfo info, HttpServletRequest request) {
        if (!"".equals(saveFileName)) {
            info.setpImage(saveFileName);
        }
        int num = productInfoService.update(info);
        if (num == 1) {
            request.setAttribute("msg", "更新成功");
        } else {
            request.setAttribute("msg", "更新失败");
        }
        saveFileName = "";
        return "forward:/prod/split.action";
    }

    @RequestMapping("delete.action")
    public String delete(Integer pId, ProductInfoVo vo, HttpServletRequest request) {
        int num = productInfoService.delete(pId);
        if (num == 1) {
            request.setAttribute("msg", "删除成功");
            request.getSession().setAttribute("vo", vo);
        } else {
            request.setAttribute("msg", "删除失败");
        }
        return "forward:/prod/deleteAjaxSplit.action";
    }

    @ResponseBody
    @RequestMapping(value = "/deleteAjaxSplit.action", produces = "text/html;charset=UTF-8")
    public Object deleteAjaxSplit(HttpSession session, HttpServletRequest request) {
        PageInfo<ProductInfo> info = null;
        Object vo = request.getSession().getAttribute("vo");
        if (vo != null) {
            info = productInfoService.splitByCondition((ProductInfoVo) vo, PAGE_SIZE);
            request.getSession().removeAttribute("vo");
        } else {
            info = productInfoService.split(1, PAGE_SIZE);
        }
        session.setAttribute("info", info);
        return request.getAttribute("msg");
    }

    @RequestMapping(value = "/deleteBatch.action")
    public String deleteBatch(String pIds, ProductInfoVo vo, HttpServletRequest request) {
        String[] pId = pIds.split(",");
        int num = productInfoService.deleteBatch(pId);
        if (num == pId.length) {
            request.setAttribute("msg", "删除成功");
            request.getSession().setAttribute("vo", vo);
        } else {
            request.setAttribute("msg", "删除失败");
        }
        return "forward:/prod/deleteAjaxSplit.action";
    }

    @ResponseBody
    @RequestMapping(value = "/condition.action")
    public void selectByCondition(ProductInfoVo vo, HttpSession session) {
        List<ProductInfo> list = productInfoService.selectByCondition(vo);
        session.setAttribute("list", list);
    }
}

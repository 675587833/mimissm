package com.bjpowernode.listener;

import com.bjpowernode.pojo.ProductType;
import com.bjpowernode.service.ProductTypeService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;

@WebListener
public class ProductTypeListener  implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext_*.xml");
        ProductTypeService productTypeService = (ProductTypeService) ac.getBean("productTypeServiceImpl");
        List<ProductType> typeList = productTypeService.getAll();
        event.getServletContext().setAttribute("typeList",typeList);
    }
}

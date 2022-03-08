<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript">
        if ("${msg}" != "") {
            alert("${msg}");
        }
    </script>
    <c:remove var="msg"></c:remove>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bright.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/addBook.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <title></title>
</head>
<script type="text/javascript">

    $(function () {
        $(".btn-info").on("click", function () {
            //浏览不关，第二次打开时要清空
            $("#myModal").modal("hide");
        });
        //新增学生非空判断
        $(".btn-success").on("click", function () {
            $("#myModal").modal("hide");
        });
    })

    function ajaxsplit(pageNum) {

        var pName = $("#pName").val();
        var typeId = $("#typeId").val();
        var lPrice = $("#lPrice").val();
        var hPrice = $("#hPrice").val();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/prod/ajaxsplit.action",
            data: {
                "pageNum": pageNum,
                "pName": pName,
                "typeId": typeId,
                "lPrice": lPrice,
                "hPrice": hPrice
            },
            success: function () {
                $("#table").load("http://localhost:8080/admin/product.jsp #table");

            }
        })
    }

    function one(pId, pageNum) {
        var pName = $("#pName").val();
        var typeId = $("#typeId").val();
        var lPrice = $("#lPrice").val();
        var hPrice = $("#hPrice").val();
        var str = "?pId=" + pId + "&pageNum=" + pageNum + "&pName=" + pName + "&typeId=" + typeId + "&lPrice=" + lPrice + "&hPrice=" + hPrice;
        window.location.href = "${pageContext.request.contextPath}/prod/one.action" + str;
    }

    function del(pId,pageNum) {

        if (confirm("确定删除吗")) {
            var pName = $("#pName").val();
            var typeId = $("#typeId").val();
            var lPrice = $("#lPrice").val();
            var hPrice = $("#hPrice").val();
            $.ajax({
                type: "post",
                url: "${pageContext.request.contextPath}/prod/delete.action",
                data: {
                    "pId": pId,
                    "pageNum":pageNum,
                    "pName": pName,
                    "typeId": typeId,
                    "lPrice": lPrice,
                    "hPrice": hPrice
                },
                success: function (msg) {
                    alert(msg);
                    $("#table").load("${pageContext.request.contextPath}/admin/product.jsp  #table");
                },
                dataType: "text"
            })
        }
    }

    function allClick() {
        var flag = $("#all").prop("checked");
        $("input[name='ck']").each(function () {
            this.checked = flag;
        })
    }

    function ckClick() {
        var length = $("input[name='ck']").length;
        var ckLength = $("input[name='ck']:checked").length;
        if (length == ckLength) {
            $("#all").prop("checked", true);
        } else {
            $("#all").prop("checked", false);
        }
    }

    function deleteBatch(pageNum) {
        var cks = $("input[name='ck']:checked");
        if (cks.length == 0) {
            alert("请选择需要删除的商品");
        } else {
            if (confirm("确定删除商品吗")) {
                var pIds = "";
                var pName = $("#pName").val();
                var typeId = $("#typeId").val();
                var lPrice = $("#lPrice").val();
                var hPrice = $("#hPrice").val();
                $.each(cks, function () {
                    var pId = $(this).val();
                    if (pId != null) {
                        pIds += pId + ",";
                    }
                })
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/prod/deleteBatch.action",
                    data: {
                        "pIds": pIds,
                        "pageNum":pageNum,
                        "pName": pName,
                        "typeId": typeId,
                        "lPrice": lPrice,
                        "hPrice": hPrice
                    },
                    success: function (msg) {
                        alert(msg);
                        $("#table").load("${pageContext.request.contextPath}/admin/product.jsp #table");
                    },
                    dataType: "text"
                })
            }
        }

    }

    function condition() {
        var pName = $("#pName").val();
        var typeId = $("#typeId").val();
        var lPrice = $("#lPrice").val();
        var hPrice = $("#hPrice").val();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/prod/ajaxsplit.action",
            data: {
                "pName": pName,
                "typeId": typeId,
                "lPrice": lPrice,
                "hPrice": hPrice
            },
            success: function () {
                $("#table").load("${pageContext.request.contextPath}/admin/product.jsp #table");
            }
        })
    }


</script>
<body>
<div id="brall">
    <div id="nav">
        <p>商品管理>商品列表</p>
    </div>
    <div id="condition" style="text-align: center">
        <form id="myform">
            商品名称：<input name="pName" id="pName">&nbsp;&nbsp;&nbsp;
            商品类型：<select name="typeId" id="typeId">
            <option value="-1">请选择</option>
            <c:forEach items="${typeList}" var="type">
                <option value="${type.typeId}">${type.typeName}</option>
            </c:forEach>
        </select>&nbsp;&nbsp;&nbsp;
            价格：<input name="lPrice" id="lPrice">-<input name="hPrice" id="hPrice">
            <input type="button" value="查询" onclick="condition()">
        </form>
    </div>
    <br>
    <div id="table">

        <c:choose>
            <c:when test="${info.list.size()!=0}">

                <div id="top">
                    <input type="checkbox" id="all" onclick="allClick()" style="margin-left: 50px">&nbsp;&nbsp;全选
                    <a href="${pageContext.request.contextPath}/admin/addproduct.jsp">

                        <input type="button" class="btn btn-warning" id="btn1"
                               value="新增商品">
                    </a>
                    <input type="button" class="btn btn-warning" id="btn1"
                           value="批量删除" onclick="deleteBatch(${info.pageNum})">
                </div>
                <!--显示分页后的商品-->
                <div id="middle">
                    <table class="table table-bordered table-striped">
                        <tr>
                            <th></th>
                            <th>商品名</th>
                            <th>商品介绍</th>
                            <th>定价（元）</th>
                            <th>商品图片</th>
                            <th>商品数量</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${info.list}" var="p">
                            <tr>
                                <td valign="center" align="center"><input type="checkbox" name="ck" id="ck"
                                                                          value="${p.pId}" onclick="ckClick()"></td>
                                <td>${p.pName}</td>
                                <td>${p.pContent}</td>
                                <td>${p.pPrice}</td>
                                <td><img width="55px" height="45px"
                                         src="${pageContext.request.contextPath}/image_big/${p.pImage}"></td>
                                <td>${p.pNumber}</td>
                                    <%--<td><a href="${pageContext.request.contextPath}/admin/product?flag=delete&pid=${p.pId}" onclick="return confirm('确定删除吗？')">删除</a>--%>
                                    <%--&nbsp;&nbsp;&nbsp;<a href="${pageContext.request.contextPath}/admin/product?flag=one&pid=${p.pId}">修改</a></td>--%>
                                <td>
                                    <button type="button" class="btn btn-info "
                                            onclick="one(${p.pId},${info.pageNum})">编辑
                                    </button>
                                    <button type="button" class="btn btn-warning" id="mydel"
                                            onclick="del(${p.pId},${info.pageNum})">删除
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                    <!--分页栏-->
                    <div id="bottom">
                        <div>
                            <nav aria-label="..." style="text-align:center;">
                                <ul class="pagination">
                                    <li>
                                            <%--                                        <a href="${pageContext.request.contextPath}/prod/split.action?page=${pb.prePage}" aria-label="Previous">--%>
                                        <a href="javascript:ajaxsplit(${info.prePage})" aria-label="Previous">

                                            <span aria-hidden="true">«</span></a>
                                    </li>
                                    <c:forEach begin="1" end="${info.pages}" var="i">
                                        <c:if test="${info.pageNum==i}">
                                            <li>
                                                    <%--                                                <a href="${pageContext.request.contextPath}/prod/split.action?page=${i}" style="background-color: grey">${i}</a>--%>
                                                <a href="javascript:ajaxsplit(${i})"
                                                   style="background-color: grey">${i}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${info.pageNum!=i}">
                                            <li>
                                                    <%--                                                <a href="${pageContext.request.contextPath}/prod/split.action?page=${i}">${i}</a>--%>
                                                <a href="javascript:ajaxsplit(${i})">${i}</a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <li>
                                            <%--  <a href="${pageContext.request.contextPath}/prod/split.action?page=1" aria-label="Next">--%>
                                        <a href="javascript:ajaxsplit(${info.nextPage})" aria-label="Next">
                                            <span aria-hidden="true">»</span></a>
                                    </li>
                                    <li style=" margin-left:150px;color: #0e90d2;height: 35px; line-height: 35px;">总共&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pages}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <c:if test="${info.pageNum!=0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pageNum}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                        <c:if test="${info.pageNum==0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">1</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <h2 style="width:1200px; text-align: center;color: orangered;margin-top: 100px">暂时没有符合条件的商品！</h2>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<!--编辑的模式对话框-->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">新增商品</h4>
            </div>
            <div class="modal-body" id="addTD">
                <form action="${pageContext.request.contextPath}/admin/product?flag=save" enctype="multipart/form-data"
                      method="post" id="myform">
                    <table>
                        <tr>
                            <td class="one">商品名称</td>
                            <td><input type="text" name="pname" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="pnameerr"></span></td>
                        </tr>
                        <tr>
                            <td class="one">商品介绍</td>
                            <td><input type="text" name="pcontent" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="pcontenterr"></span></td>
                        </tr>
                        <tr>
                            <td class="one">定价</td>
                            <td><input type="number" name="pprice" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="priceerr"></span></td>
                        </tr>

                        <tr>
                            <td class="one">图片介绍</td>
                            <td><input type="file" name="pimage" class="form-control"></td>
                        </tr>
                        <tr class="three">
                            <td class="four"></td>
                            <td><span></span></td>
                        </tr>

                        <tr>
                            <td class="one">总数量</td>
                            <td><input type="number" name="pnumber" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="numerr"></span></td>
                        </tr>


                        <tr>
                            <td class="one">类别</td>
                            <td>
                                <select name="typeid" class="form-control">
                                    <c:forEach items="${typeList}" var="type">
                                        <option value="${type.typeId}">${type.typeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span></span></td>
                        </tr>

                        <tr>
                            <td>
                                <input type="submit" class="btn btn-success" value="提交" class="btn btn-success">
                            </td>
                            <td>
                                <button type="button" class="btn btn-info" data-dismiss="modal">取消</button>
                            </td>
                        </tr>
                    </table>
                </form>

            </div>

        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal -->
</div>
</body>

</html>
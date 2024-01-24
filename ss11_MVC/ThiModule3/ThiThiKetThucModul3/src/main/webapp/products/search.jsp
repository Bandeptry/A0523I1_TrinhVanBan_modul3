<%--
  Created by IntelliJ IDEA.
  User: hp
  Date: 19/12/2023
  Time: 11:03 p.m.
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.1/css/bootstrap.min.css"
          integrity="sha512-Ez0cGzNzHR1tYAv56860NLspgUGuQw16GiOOp/I2LuTmpSK9xDXlgJz3XN4cnpXWDmkNBKXR/VDMTCnAaEooxA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.10.1/sweetalert2.css" integrity="sha512-pxzljms2XK/DmQU3S58LhGyvttZBPNSw1/zoVZiYmYBvjDQW+0K7/DVzWHNz/LeiDs+uiPMtfQpgDeETwqL+1Q=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/11.10.1/sweetalert2.min.js" integrity="sha512-lhtxV2wFeGInLAF3yN3WN/2wobmk+HuoWjyr3xgft42IY0xv4YN7Ao8VnYOwEjJH1F7I+fadwFQkVcZ6ege6kA=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>

</head>
<body>
<div class="container">
    <div class="head d-flex justify-content-between mt-3">
        <a href="/products?action=create"><button class="btn btn-primary" type="submit">Create</button></a>
        <a href="/products"><button class="btn btn-dark">Back</button></a>
    </div>
    <div class="center">
        <c:if test="${messageSearch != null}">
            <script>
                window.onload = ()=>
                {
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: "${messageSearch}",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
            </script>
        </c:if>
    <c:if test="${messageSearch =!null}">
        <table class="table table-striped">
            <thead>
            <tr class="col-4">
                <th>#</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Color</th>
                <th>Category</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${products}" var="i" varStatus="loop">
                <tr>
                    <td>
                            ${i.getId()}
                    </td>
                    <td>${i.getTenSanPham()}</td>
                    <td>${i.getGia()}</td>
                    <td>${i.getSoLuong()}</td>
                    <td>${i.getMauSac()}</td>
                        <c:forEach items="${categoryList}" var="ct">
                        <c:if test="${ct.getIdCate() == i.getCategory().getIdCate()}">
                    <td>
                            ${i.getCategory().getCategory()}
                    </td>
                    </c:if>
                    </c:forEach>
                    <td>
                        <a href="/products?action=edit&id=${i.getId()}"><i class="fa-solid fa-pen-to-square"></i></a>
                        <a class="offset-1" onclick="handleDeleteClick(${i.getId()}, '${i.getTenSanPham()}')"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
</c:if>
    </div>
</div>
<script>
    function handleDeleteClick(id, name) {
        Swal.fire({
            title: "Bạn chắc chắn chứ?",
            text: "Bạn có muốn xóa " + name + " không?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Có, xóa đi!",
            htmlMode: true
        }).then((result) => {
            if (result.isConfirmed) {
                location.assign("/products?action=delete&id=" + id);
            }
        });
    }
</script>
</body>
</html>

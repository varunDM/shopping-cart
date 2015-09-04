$(function() {

    // Cart Count

    var count = $('.product').length;
    $('.cart-count').html(count);

    // Mini-cart remove
    $('.mini-cart').delegate(".mini-cart-remove", "click", function(event) {
        event.preventDefault();
        var t = $(this);
        var prod_index = t.attr('data-index');
        formatted_prod_index = parseInt(prod_index);
        $.ajax({
            url: '/remove_from_cart',
            method: 'POST',
            data: {
                arr_pos: formatted_prod_index
            },
            success: function(data) {
                // Remove current element
                t.parent().remove();

                // Iterate through the products and change data index
                $('.mini-cart-remove').each(function(index) {
                    $(this).attr("data-index", index);
                });

                // get old count and minus by one
                count = $('.cart-count').text();
                formatted_count = parseInt(count) - 1;
                $('.cart-count').html(formatted_count);

                // When cart is empty
                empty_cart = '<div class="mini-cart-products"></div><div class="empty-cart" style="color: #A1A1A1; text-align: center;padding: 50px 0px; font-size: 20px;">Cart is empty !</div>';

                if ($('.product').length == 0) {
                    $('.mini-cart').html(empty_cart);
                }

            },
            error: function() {
                alert("Error");
            }
        });
    });

    // Product search by name

    $('#search_form').submit(function(event) {

        event.preventDefault();
        $.ajax({

            url: '/search',

            method: 'POST',

            data: {
                query: $('#query').val(),
                type: "products.name"
            },

            success: function(data) {
                $('.flexslider').hide();
                $('.products-container').html(data);
            },
            error: function() {
                alert("Error");
            }
        });
    });

    // Navbar - Category search

    $('#categories li a').click(function() {
        var category = $.trim($(this).text());
        $.fn.categorySearch(category);
    });

    $.fn.categorySearch = function(category) {

        $.ajax({

            url: '/search',

            method: 'POST',

            data: {
                query: category,
                type: 'categories.name'
            },

            success: function(data) {
                $('.flexslider').hide();
                $('.products-container').html(data);
            },
            error: function() {
                alert('Error');
            }
        });
    }
});
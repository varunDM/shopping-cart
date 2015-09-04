$(function() {

    // Add to Cart
    
    $('.products-container').delegate(".add-to-cart", "click", function() {

        $.ajax({

            url: '/add_to_cart',
            method: 'POST',
            data: {
                product: $(this).attr('productid'),
                quantity: 1
            },
            success: function(data) {

                $('.mini-cart').html(data);
                // get new count
                count = $('.mini-cart-products .product').size();
                $('.cart-count').html(count);
            },
            error: function() {
                alert('Error');
            }
        });
    });

    // Carousal

    $('.flexslider').flexslider({
        animation: "slide"
    });

    // Auto complete

    $("#query").autocomplete({
        minLength: 2
    }, {

        select: function(event, ui) {
            // On selecting a category
            if (ui.item.type == 'category') {
                $.fn.categorySearch(ui.item.label);
            }
        },
        source: function(request, response) {
            $.ajax({
                url: '/autocomplete',
                method: 'POST',
                data: {
                    query: $('#query').val()
                },
                success: function(data) {
                    response(data);
                    // headers for search lists
                    $('.search-product-item:first-child').before('<b class="search_header">Products</b>');
                    $('.search-category-item').first().before('<b class="search_header">Categories</b>');

                },
                error: function() {
                    alert('Error');
                }
            });
        }
    });

    if(typeof($("#query").autocomplete().data()) !== "undefined") {
        $("#query").autocomplete().data("uiAutocomplete")._renderItem = function(ul, item) {
            if (item.type == 'product') {
                return $('<li class="search-product-item">')
                    .append('<a href="product/' + item.id + '">' + item.label + '</a>')
                    .appendTo(ul);
            }
            return $('<li class="search-category-item">')
                .append(item.label)
                .appendTo(ul);
        };
    } 

        


});



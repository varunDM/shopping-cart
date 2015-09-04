$(function() {

    // Buy now
    $('#buy_now').submit(function(event) {
        event.preventDefault(); // prevent form submission
        var status;
        $.fn.checkInventory(function(output) {
            status = output;
            console.log('buy: ' + status);
            if (status == false) { // check for stock
                console.log('Inventory exhausted');
                $('#exhaust-button').click();
            } else {
                $('#buy_now').unbind('submit').submit(); // resume form submission
            }
        });

    });

    // Add to cart
    $('.add-to-cart').click(function() {
        if (parseInt($('#quantity').val()) > 0) { // check value is greater than 0

            $.fn.checkInventory(function(output) {
                var status = output;
                console.log('cart: ' + status);
                if (status == false) { // check for stock
                    console.log('Inventory exhausted');
                    $('#exhaust-button').click();
                } else { //ajax call

                    $.ajax({

                        url: '/add_to_cart',
                        method: 'POST',
                        data: {
                            product: $('.add-to-cart').attr('productid'),
                            quantity: $('#quantity').val()
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

                }
            });


        } else {
            $('#flash1').fadeIn().delay(1500).fadeOut("slow"); // flash message if invalid quantity
        }
    });

    $.fn.checkInventory = function(handleData) {
        $.ajax({
            url: '/check_inventory',
            method: 'POST',
            data: {
                product: $('.buy-now').attr('productid'),
                quantity: $('#quantity').val()
            },
            success: function(data) {
                console.log('ajax.success: ' + data);
                handleData(data);
            },
            error: function() {
                alert('Error');
            }
        });
    }

    // Change blowup image on clicking small images
    $('.tiny-image').click(function() {
        var path = $(this).children('img').attr('src');
        $('#blowup img').attr('src', path);
    });

    // Zoom blowup on hover
    var blowup_image_path = $('#blowup img').attr('src');
    $('#blowup').zoom({
        url: blowup_image_path,
        magnify: 1.5
    });
});
exports.handler = async (event) => {
    console.log('Booking system function called');
    return {
        statusCode: 200,
        body: JSON.stringify('Booking system function working!')
    };
};

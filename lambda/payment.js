exports.handler = async (event) => {
    console.log('Payment processor function called');
    return {
        statusCode: 200,
        body: JSON.stringify('Payment processor function working!')
    };
};

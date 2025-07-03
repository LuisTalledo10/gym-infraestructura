exports.handler = async (event) => {
    console.log('User management function called');
    return {
        statusCode: 200,
        body: JSON.stringify('User management function working!')
    };
};

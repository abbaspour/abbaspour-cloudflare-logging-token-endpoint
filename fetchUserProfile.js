function fetchUserProfile(access_token, ctx, callback) {
    'use strict';

    const jsonwebtoken = require('jsonwebtoken');

    console.log('ctx: ' + JSON.stringify(ctx));

    const { id_token } = ctx;
    if (!id_token) {
        return callback('missing-id_token');
    }

    const jwt = jsonwebtoken.decode(id_token);

    if (!jwt)
        return callback('malformed-id_token');

    if (!jwt.sub)
        return callback('missing-sub');

    if (!jwt.email)
        return callback('missing-email');


    const profile = {
        user_id: jwt.sub.replace(/^auth0\|/, ''),
        email: jwt.email,
        user_metadata: {},
        app_metadata: {}
    };

    if (jwt.picture) profile.picture = jwt.picture;
    if (jwt.name) profile.name = jwt.name;
    if (jwt.given_name) profile.given_name = jwt.given_name;
    if (jwt.family_name) profile.family_name = jwt.family_name;

    return callback(null, profile);
}

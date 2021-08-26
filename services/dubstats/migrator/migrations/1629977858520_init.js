/* eslint-disable camelcase */

exports.shorthands = undefined;

exports.up = pgm => {
    pgm.createTable('package', {
        id: 'id',
        name: { type: 'text', notNull: true }
        // TODO, the rest of this.
    })
};

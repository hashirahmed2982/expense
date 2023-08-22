const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let ExpenseSchema = new Schema({
name: {
	type: String
},
type: {
	type: String
},
amount: {
	type: Number
}
}, {
	collection: 'expense'
})

module.exports = mongoose.model('expense', ExpenseSchema)

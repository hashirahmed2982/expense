let mongoose = require("mongoose"),
express = require("express"),
router = express.Router();

// Student Model
let ExpenseSchema = require("../models/Student");

// CREATE Student
router.post("/create-data", (req, res, next) => {
    console.log("in");
ExpenseSchema.create(req.body).then((result) => {
    res.json(result);
})
.catch((err)=>{
    next(err);
})
});

// READ Students
router.get("/", (req, res , next) => {
    console.log("out");
ExpenseSchema.find().then((result) => {
    res.json(result);
})
.catch((err)=>{
    next(err);
})
});

// UPDATE student
router
.route("/update-data/:id")
// Get Single Student
.get((req, res,next) => {
	ExpenseSchema.findById
		(req.params.id).then((result) => {
            res.json(result);
        })
        .catch((err)=>{
            next(err);
        })
})

// Update Student Data
.put((req, res, next) => {
	ExpenseSchema.findByIdAndUpdate(
	req.params.id,
	{
		$set: req.body,
	}).then((result) => {
        res.json(result);
		console.log("Student updated successfully !");
    })
    .catch((err)=>{
        next(err);
    })
});

// Delete Student
router.delete("/delete-data/:id",
(req, res, next) => {
ExpenseSchema.findByIdAndRemove(
	req.params.id).then((result) => {
        res.status(200).json({
            msg: result,
        });
    })
    .catch((err)=>{
        next(err);
    })
    
});

module.exports = router;

try{
  require('coffee-script')
  cs = true
}catch(e){}
module.exports = require(cs ? './src' : './lib')
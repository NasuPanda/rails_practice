const axios = require('axios').default;
const url = 'https://www.reddit.com/r/vue.json'

axios.get(url)
  .then((res) => {
    console.log(res.data)
  })
  .catch((err) => {
    console.log("An error occur!")
    console.log(err)
  })
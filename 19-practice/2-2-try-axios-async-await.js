const axios = require('axios').default;
const url = 'https://www.reddit.com/r/vue.json'

const getVueArticle = async (url) => {
  try {
    const response = await axios.get(url);
    return response
  } catch(err) {
    console.log("An error occur!")
    console.log(err)
  }
}

getVueArticle(url).then(res => console.log(res))
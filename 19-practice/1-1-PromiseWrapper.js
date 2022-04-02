// setTimeout() を Promise でラップしたものを返す sleep(ms) 関数を作り、
// sleep(ms) を呼び、
// .then でチェーンさせた内部でもう一度 sleep(ms) を return し、
// .then が2個チェーンした形になるようにしてください。

const sleep = (ms) => {
  return new Promise((resolve) => {
    setTimeout(()=> {
      console.log("timeout", ms)
      resolve(`then ${ms}`)
    }, 1000);
  });
}

sleep(1000)
  .then((v) => {
    console.log(v)
    return sleep(2000)
  })
  .then((v) => {
    console.log(v)
  })

// 出力
// timeout 1000
// then 1000
// timeout 2000
// then 2000

// 解説
// Promiseは引数としてresolve, rejectを取る。
// resolve,/rejectはそれぞれ非同期処理の完了/失敗を意味する。
// 例えば以下のようにすると、
new Promise((resolve) => {
  setTimeout(()=> {
    console.log("timeout", ms)
    resolve("then")
  }, 1000);
});
// 1000ms経過後にresolve()が実行される。すなわち、非同期処理が完了する。

// .thenは引数としてresolveに渡した引数を受け取る事ができる。
// 例えば以下のようにすると、
new Promise(resolve => resolve("then"))
  .then(v => {console.log(v)})
// 引数vにはresolveに渡された"then"が入る。
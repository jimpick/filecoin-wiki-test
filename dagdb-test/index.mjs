import { promises as fs } from 'fs'
import dagdb from 'dagdb'

async function run () {
  let db = await dagdb.create('inmem')

  const majorMinors = []

  const dir = '../wiki-small-blocks'
  const files = await fs.readdir(dir)
  let count = 0
  for (const file of files) {
    const match = file.match(/^wiki\.zip\.(..)\.(..)\.cid$/)
    if (match) {
      const [, major, minor] = match
      const rawCid = await fs.readFile(`${dir}/wiki.zip.${major}.${minor}.cid`)
      const cid = rawCid.toString().replace(/\n$/, '')
      console.log(major, minor, cid)
      const majorMinor = `${major}-${minor}`
      majorMinors.push(majorMinor)
      await db.set(majorMinor, cid)
      /*
      if (++count % 5 === 0) {
        db = await db.update()
        console.log('Jim update', db)
      }
      */
      if (++count > 388) { // 387 is ok
        break
      }
    }
  }
  await db.set('majorMinors', majorMinors)
  // console.log('Jim files', files)

  await db.set('hello', 'world')
  await db.set('hello2', 'world2')
  console.log(await db.get('hello'))

  db = await db.update()

  /*
  console.log('Jim db', await db.info())
  console.log('Jim db encode')
  for await (const x of db.encode()) {
    console.log('Jim x', x)
  }
  */
}

run()

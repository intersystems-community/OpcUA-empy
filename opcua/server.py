import logging
import asyncio
import sys
import argparse

from random import randrange

from asyncua import ua, Server
from asyncua.common.methods import uamethod

logging.basicConfig(
    format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s %(funcName)-8s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S')



@uamethod
def func(parent, value):
    return value * 2


async def main(nodes: int, sleep: float):
    _logger = logging.getLogger('asyncua')
    # setup our server
    server = Server()
    await server.init()
    server.set_endpoint('opc.tcp://0.0.0.0:4840/freeopcua/server/')

    # setup our own namespace, not really necessary but should as spec
    uri = 'http://examples.freeopcua.github.io'
    idx = await server.register_namespace(uri)

    # populating our address space
    # server.nodes, contains links to very common nodes like objects and root
    myobj = await server.nodes.objects.add_object(idx, 'MyObject')

    myvars = []
    for i in range(nodes):
        myvar = await myobj.add_variable(idx, f'MyVariable{i}', randrange(100))
        await myvar.set_writable()
        myvars.append(myvar)

    await server.nodes.objects.add_method(ua.NodeId('ServerMethod', 2), ua.QualifiedName('ServerMethod', 2), func, [ua.VariantType.Int64], [ua.VariantType.Int64])
    _logger.info('Starting server!')
    async with server:
        while True:
            await asyncio.sleep(sleep)
            myvar = myvars[randrange(nodes)]
            new_val = await myvar.get_value() + 0.1
            await myvar.write_value(new_val)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Start OpcUA server.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--nodes', type=int, default=100, nargs='?', help='Number of nodes to publish.')
    parser.add_argument('--sleep', type=float, default=0.1, nargs='?', help='Sleep (in seconds) between nodes modifications.')
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG)
    asyncio.run(main(args.nodes, args.sleep), debug=False)
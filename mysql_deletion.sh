NOVA_LIST=$(openstack server list -c ID -f value --os-password=redhat --os-username=operator1 --os-user-domain-name=Example --os-auth-url=http://172.25.250.50:5000/v3  )

for i in $NOVA_LIST; do 
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.block_device_mapping set block_device_mapping.deleted_at="2022-11-04 04:21:48", block_device_mapping.deleted=block_device_mapping.id where block_device_mapping.instance_uuid="${i}";'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.instance_extra set instance_extra.deleted_at="2022-11-04 04:21:48" , instance_extra.deleted=instance_extra.id where instance_uuid="${i}";'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.instance_id_mappings  set instance_id_mappings.deleted_at="2022-11-04 04:21:48" , instance_id_mappings.deleted=instance_id_mappings.id where uuid="${i}" ;'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.instance_info_caches set instance_info_caches.deleted_at="2022-11-04 04:21:48", instance_info_caches.network_info='[]', instance_info_caches.deleted=instance_info_caches.id where instance_uuid="${i}" \G;'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.instance_system_metadata set instance_system_metadata.deleted_at="2022-11-04 04:21:48" , instance_system_metadata.deleted=instance_system_metadata.id where instance_uuid="${i}" ;'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.instances set instances.updated_at="2022-11-04 04:21:47" , instances.deleted_at="2022-11-04 04:21:48" , instances.vm_state=deleted , instances.terminated_at="2022-11-04 04:21:47", instances.deleted=instances.id , instances.cleaned=1 where instances.uuid="${i}";'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'update nova.virtual_interfaces set virtual_interfaces.deleted_at='2022-11-04 04:21:47' , virtual_interfaces.deleted=virtual_interfaces.id where instance_uuid="${i}" ;'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'delete from placement.consumers where uuid="${i}";'
mysql -uroot -pbeJQpMgiSi -hlocalhost -e 'delete from placement.allocations where consumer_id="${i}";'


PORT_LIST=`for j in $NOVA_LIST ; do  openstack port list -c ID -f value --server ${j} --os-password=redhat --os-username=operator1 --os-user-domain-name=Example --os-auth-url=http://172.25.250.50:5000/v3 ; done`
for k in $PORT_LIST; do
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.ipallocations where port_id="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.ml2_port_binding_levels where port_id="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.ml2_port_bindings where port_id="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.ovn_revision_numbers where resource_uuid="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.ports where id="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.portsecuritybindings where port_id="${k}";'
mysql -u root -pbeJQpMgiSi -hlocalhost -e 'delete from ovs_neutron.securitygroupportbindings where port_id="${k}";'
done
done
